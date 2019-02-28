extension Conveyor {
    func withLatest<R, NewEvent>(from conveyor: Conveyor<R, Scheduler>, using predicate: @escaping (Event, R) -> NewEvent) -> Conveyor<NewEvent, Scheduler> {
        let run = self.run(silo:)
        return Conveyor<NewEvent, Scheduler> { silo in
            var latest: R?
            let firstTrash = run(Silo { event in
                guard let latest = latest else {
                    return
                }
                let newEvent = predicate(event, latest)
                silo.fire(event: newEvent)
            })
            let secondTrash = conveyor.run(silo: Silo { event in
                latest = event
            })
            let trash = TrashCompositeTwo(primary: firstTrash, secondary: secondTrash)
            return trash
        }
    }
}
