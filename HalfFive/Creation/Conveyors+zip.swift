public extension Conveyors {
    static func zip<L: ConveyorType, R: ConveyorType>(_ lhs: L, _ rhs: R, combiner: @escaping (L.Event, R.Event) -> Event) -> Conveyor<Event, L.Scheduler, HotnessHot> where L.Scheduler == R.Scheduler, L.Hotness == HotnessHot, R.Hotness == HotnessHot {
        return zip(lhs, rhs, combiner: combiner)
            .convertToHot()
    }
    
    static func zip<L: ConveyorType, R: ConveyorType>(_ lhs: L, _ rhs: R, combiner: @escaping (L.Event, R.Event) -> Event) -> Conveyor<Event, L.Scheduler, HotnessCold> where L.Scheduler == R.Scheduler {
        return .init { handler in
            let trash = ZipTrash<L.Event, R.Event>()
            weak var weakTrash = trash
            
            let process = { (index: Int) in
                guard let trash = weakTrash else {
                    return
                }
                guard let zip = trash.events[index] else {
                    return
                }
                guard let (left, right) = zip.events else {
                    return
                }
                let resulting = combiner(left, right)
                handler(resulting)
                trash.events[index] = nil
            }
            
            let leftTrash, rightTrash: Trash
            
            var leftCount = 0
            
            leftTrash = lhs.run { event in
                guard let trash = weakTrash else {
                    return
                }
                let index = leftCount
                leftCount += 1
                
                
                trash.events[index] = EventZip(lhs: .some(event), rhs: trash.events[index]?.rhs ?? .uninit)
                
                process(index)
            }
            
            var rightCount = 0
            
            rightTrash = rhs.run { event in
                guard let trash = weakTrash else {
                    return
                }
                let index = rightCount
                rightCount += 1
                
                trash.events[index] = EventZip(lhs: trash.events[index]?.lhs ?? .uninit, rhs: .some(event))
                
                process(index)
            }
            
            trash.composite = TrashCompositeTwo(primary: leftTrash, secondary: rightTrash)
            
            return trash
        }
    }
}

private enum EventState<Event> {
    case uninit
    case some(Event)
}

private struct EventZip<L, R> {
    static var empty: EventZip {
        return EventZip(lhs: .uninit, rhs: .uninit)
    }
    
    let lhs: EventState<L>
    let rhs: EventState<R>
    
    init(lhs: EventState<L>, rhs: EventState<R>) {
        self.lhs = lhs
        self.rhs = rhs
    }
    
    var events: (L, R)? {
        if case .some(let lhs) = lhs, case .some(let rhs) = rhs {
            return (lhs, rhs)
        }
        return nil
    }
}

private class ZipTrash<LE, RE>: Trash {
    var events = [Int: EventZip<LE, RE>]()
    var composite: TrashCompositeTwo?
    
    init() {
        
    }
}
