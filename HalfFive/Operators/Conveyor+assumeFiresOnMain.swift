public extension ConveyorType where Scheduler: SchedulingHot {
    func assumeFiresOnMain() -> Conveyor<Event, SchedulingMain> {
        let run = self.run(handler:)
        return .init { handler in
            return run(handler)
        }
    }
}
