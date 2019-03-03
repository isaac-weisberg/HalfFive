public extension Conveyor {
    static func zip<L: ConveyorType, R: ConveyorType>(_ lhs: L, _ rhs: R, combiner: @escaping (L.Event, R.Event) -> Event) -> Conveyor where L.Scheduler == Scheduler, R.Scheduler == Scheduler {
        return Conveyor { handler in
            var events = [Int: EventZip<L.Event, R.Event>]()
            
            let process = { (index: Int) in
                guard let zip = events[index] else {
                    return
                }
                guard let (left, right) = zip.events else {
                    return
                }
                let resulting = combiner(left, right)
                handler(resulting)
                events[index] = nil
            }
            
            let leftTrash, rightTrash: Trash
            
            var leftCount = 0
            
            leftTrash = lhs.run { event in
                let index = leftCount
                leftCount += 1
                
                
                events[index] = EventZip(lhs: .some(event), rhs: events[index]?.rhs ?? .uninit)
                
                process(index)
            }
            
            var rightCount = 0
            
            rightTrash = rhs.run { event in
                let index = rightCount
                rightCount += 1
                
                events[index] = EventZip(lhs: events[index]?.lhs ?? .uninit, rhs: .some(event))
                
                process(index)
            }
            
            return TrashCompositeTwo(primary: leftTrash, secondary: rightTrash)
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
