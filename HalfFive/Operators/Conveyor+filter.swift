public extension ConveyorType {
    func filter(_ predicate: @escaping (Event) -> Bool) -> Conveyor<Event, Scheduler, Hotness> {
        let run = self.run(handler:)
        return .unsafe { handler in
            run { event in
                if predicate(event) {
                    handler(event)
                }
            }
        }
    }
}
