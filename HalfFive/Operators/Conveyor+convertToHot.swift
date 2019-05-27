internal extension ConveyorType where Hotness == HotnessCold {
    func convertToHot() -> Conveyor<Event, Scheduler, HotnessHot> {
        let run = self.run(handler:)
        return .unsafe { handle in
            run(handle)
        }
    }
    
    func convertIntoWhateverApplies<Hotness: HotnessTrait>() -> Conveyor<Event, Scheduler, Hotness> {
        let run = self.run(handler:)
        return .unsafe { handle in
            run(handle)
        }
    }
}
