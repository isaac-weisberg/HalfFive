public extension ConveyorType where Scheduler: SchedulingRandomOrMain {
    func assumeFiresOnMain() -> Conveyor<Event, SchedulingMain> {
        let run = self.run(handler:)
        return Conveyor<Event, SchedulingMain> { handler in
            return run(handler)
        }
    }
}
