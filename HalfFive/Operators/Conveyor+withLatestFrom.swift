extension Conveyor {
    func withLatest<R, NewEvent>(from conveyor: Conveyor<R, Scheduler>, using predicate: @escaping (Event, R) -> NewEvent) -> Conveyor<NewEvent, Scheduler> {
        let run = self.run(handler:)
        return Conveyor<NewEvent, Scheduler> { handler in
            var latest = LatestEvent<R>.uninit
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
