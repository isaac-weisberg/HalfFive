public extension Conveyors {
    static func combineLatest<L: ConveyorType, R: ConveyorType, Event>(_ lhs: L, _ rhs: R, combiner: @escaping (L.Event, R.Event) -> Event) -> Conveyor<Event, L.Scheduler, HotnessHot> where L.Scheduler == R.Scheduler, L.Hotness == HotnessHot, R.Hotness == HotnessHot {
        return combineLatest(lhs, rhs, combiner: combiner)
            .convertToHot()
    }
    
    static func combineLatest<L: ConveyorType, R: ConveyorType, Event>(_ lhs: L, _ rhs: R, combiner: @escaping (L.Event, R.Event) -> Event) -> Conveyor<Event, L.Scheduler, HotnessCold> where L.Scheduler == R.Scheduler {
        return .init { handler in
            let trash = CombineLatestTrash<L.Event, R.Event>(primary: nil, secondary: nil)
            weak var weakTrash = trash
            
            let evaluate = {
                guard let trash = weakTrash else {
                    return
                }
                switch trash.lState {
                case .uninit:
                    return
                case .live(let lEvent):
                    switch trash.rState {
                    case .uninit:
                        return
                    case .live(let rEvent):
                        let newEvent: Event = combiner(lEvent, rEvent)
                        handler(newEvent)
                    }
                }
            }
            
            trash.secondary = lhs.run { lEve in
                guard let trash = weakTrash else {
                    return
                }
                trash.lState = .live(lEve)
                evaluate()
            }
            
            trash.primary = rhs.run { rEve in
                guard let trash = weakTrash else {
                    return
                }
                trash.rState = .live(rEve)
                evaluate()
            }
            
            return trash
        }
    }
}

private enum PrivateCombinerState<Event> {
    case uninit
    case live(Event)
}

private class CombineLatestTrash<LE, RE>: TrashCompositeTwo {
    var lState = PrivateCombinerState<LE>.uninit
    var rState = PrivateCombinerState<RE>.uninit
}
