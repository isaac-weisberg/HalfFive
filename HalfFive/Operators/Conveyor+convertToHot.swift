internal extension ConveyorType where Hotness == HotnessCold {
    func convertToHot() -> Conveyor<Event, Scheduler, HotnessHot> {
        let run = self.run(handler:)
        return Conveyor { handle in
            run(handle)
        }
    }
}
