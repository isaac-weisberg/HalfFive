public extension ConveyorType {
    func distinctUntilChanged(_ areEqual: @escaping (Event, Event) -> Bool) -> Conveyor<Event, Scheduler, Hotness> {
        let run = self.run(handler:)
        return Conveyor { handle in
            let trash = DistinctUntilTrash<Event>()
            
            trash.trash = run { event in
                if case .some(let prevEvent) = trash.last, areEqual(prevEvent, event) {
                    return
                }
                trash.last = .some(event)
                handle(event)
            }
            
            return trash
        }
    }
}

private class DistinctUntilTrash<Event>: Trash {
    enum Last {
        case none
        case some(Event)
    }
    
    var last: Last = .none
    var trash: Trash?
    
    init() {
        
    }
}
