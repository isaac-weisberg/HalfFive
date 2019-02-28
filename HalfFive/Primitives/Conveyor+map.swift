extension Conveyor {
    func map<NewEvent>(predicate: @escaping (Event) -> NewEvent) -> Conveyor<NewEvent, Scheduler> {
        let run = self.run(silo:)
        return Conveyor<NewEvent, Scheduler> { silo in
            run(Silo { event in
                silo.fire(event: predicate(event))
            })
        }
    }
}
