public extension ConveyorType {
    func startWith(event: Event) -> Conveyor<Event, Scheduler, HotnessHot> {
        let run = self.run(handler:)
        return .unsafe { handler in
            handler(event)
            return run(handler)
        }
    }
}
