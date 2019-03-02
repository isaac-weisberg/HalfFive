extension Conveyor {
    static func combineLatest<L: ConveyorType, R: ConveyorType>(_ lhs: L, _ rhs: R, combiner: @escaping (L.Event, R.Event) -> Event) -> Conveyor where L.Scheduler == Scheduler, R.Scheduler == Scheduler {
        return Conveyor { silo in
            var lState = PrivateCombinerState<L.Event>.uninit
            var rState = PrivateCombinerState<R.Event>.uninit
            
            let evaluate = {
                switch lState {
                case .uninit:
                    return
                case .live(let lEvent):
                    switch rState {
                    case .uninit:
                        return
                    case .live(let rEvent):
                        let newEvent: Event = combiner(lEvent, rEvent)
                        silo.fire(event: newEvent)
                    }
                }
            }
            
            let lTrash = lhs.run(silo: Silo { lEve in
                lState = .live(lEve)
                evaluate()
            })
            
            let rTrash = rhs.run(silo: Silo { rEve in
                rState = .live(rEve)
                evaluate()
            })
            
            return TrashCompositeTwo(primary: lTrash, secondary: rTrash)
        }
    }
}

private enum PrivateCombinerState<Event> {
    case uninit
    case live(Event)
}
