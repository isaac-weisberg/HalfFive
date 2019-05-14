public extension ConveyorType where Scheduler: SchedulingRandom {
    func assumeFiresOnMain() -> Conveyor<Event, SchedulingMain, Hotness> {
        let run = self.run(handler:)
        return .init { handler in
            return run(handler)
        }
    }
}
