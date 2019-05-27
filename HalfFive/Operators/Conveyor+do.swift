public extension ConveyorType {
    func `do`(_ predicate: @escaping (Event) -> Void) -> Conveyor<Event, Scheduler, Hotness> {
        let run = self.run(handler:)
        return .unsafe { handler in
            run { event in
                predicate(event)
                handler(event)
            }
        }
    }
}
