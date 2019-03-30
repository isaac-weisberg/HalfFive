public extension ConveyorType {
    func `do`(_ predicate: @escaping (Event) -> Void) -> Conveyor<Event, Scheduler> {
        let run = self.run(handler:)
        return Conveyor { handler in
            run { event in
                predicate(event)
                handler(event)
            }
        }
    }
}