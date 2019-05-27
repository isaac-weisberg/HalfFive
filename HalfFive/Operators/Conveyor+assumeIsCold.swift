public extension ConveyorType where Hotness == HotnessHot {
    func assumeIsCold() -> Conveyor<Event, Scheduler, HotnessCold> {
        let run = self.run(handler:)
        return .unsafe { handler in
            run(handler)
        }
    }
}
