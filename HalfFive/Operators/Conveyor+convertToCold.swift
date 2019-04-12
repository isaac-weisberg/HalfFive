internal extension ConveyorType where Hotness == HotnessHot {
    func convertToCold() -> Conveyor<Event, Scheduler, HotnessCold> {
        let run = self.run(handler:)
        return Conveyor { handle in
            run(handle)
        }
    }
}
