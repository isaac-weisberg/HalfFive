extension Conveyor {
    func map<NewEvent>(predicate: @escaping (Event) -> NewEvent) -> Conveyor<NewEvent> {
        let run = self.run
        return Conveyor<NewEvent> { silo in
            run(Silo { event in
                silo.fire(predicate(event))
            })
        }
    }
}
