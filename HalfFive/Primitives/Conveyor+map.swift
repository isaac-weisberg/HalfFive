extension Conveyor {
    func map<NewEvent>(predicate: @escaping (Event) -> NewEvent) -> Conveyor<NewEvent, Scheduler> {
        let run = self.run(handler:)
        return Conveyor<NewEvent, Scheduler> { handler in
            run { event in
                handler(predicate(event))
            }
        }
    }
}
