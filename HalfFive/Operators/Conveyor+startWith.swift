public extension ConveyorType {
    func startWith(event: Event) -> Conveyor<Event, SchedulingRandom> {
        let run = self.run(handler:)
        return Conveyor { handler in
            handler(event)
            return run(handler)
        }
    }
}
