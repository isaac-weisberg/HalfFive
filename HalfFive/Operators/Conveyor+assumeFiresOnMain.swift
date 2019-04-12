public extension ConveyorType where Hotness == HotnessHot, Scheduler: SchedulingRandom {
    func assumeFiresOnMain() -> Conveyor<Event, SchedulingMain, HotnessHot> {
        let run = self.run(handler:)
        return .init { handler in
            return run(handler)
        }
    }
}
