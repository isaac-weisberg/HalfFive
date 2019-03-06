public extension ConveyorType {
    func withLatest<RC: ConveyorType, NewEvent>(from conveyor: RC, using predicate: @escaping (Event, RC.Event) -> NewEvent) -> Conveyor<NewEvent, Scheduler> {
        let run = self.run(handler:)
        return Conveyor<NewEvent, Scheduler> { handler in
            var latest = LatestEvent<RC.Event>.uninit
            let firstTrash = run { event in
                guard case .some(let latest) = latest else {
                    return
                }
                let newEvent = predicate(event, latest)
                handler(newEvent)
            }
            let secondTrash = conveyor.run { event in
                latest = .some(event)
            }
            let trash = TrashCompositeTwo(primary: firstTrash, secondary: secondTrash)
            return trash
        }
    }
}

enum LatestEvent<Event> {
    case uninit
    case some(Event)
}
