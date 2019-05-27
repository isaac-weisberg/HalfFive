public extension ConveyorType {
    func map<NewEvent>(_ predicate: @escaping (Event) -> NewEvent) -> Conveyor<NewEvent, Scheduler, Hotness> {
        let run = self.run(handler:)
        return .unsafe { handler in
            run { event in
                handler(predicate(event))
            }
        }
    }
}
