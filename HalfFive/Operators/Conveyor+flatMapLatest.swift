public extension ConveyorType {
    internal func flatMapLatestCold<NewConveyor: ConveyorType>(_ predicate: @escaping (Event) -> NewConveyor) -> Conveyor<NewConveyor.Event, NewConveyor.Scheduler, HotnessCold> {
        let run = self.run(handler:)
        return .init { handler in
            let composite = TrashCompositeTwo(primary: nil, secondary: nil)
            composite.primary = run { event in
                composite.secondary = nil
                let newConveyor = predicate(event)
                composite.secondary = newConveyor.run { event in
                    handler(event)
                }
            }
            return composite
        }
    }
    
    func flatMapLatest<NewConveyor: ConveyorType>(_ predicate: @escaping (Event) -> NewConveyor) -> Conveyor<NewConveyor.Event, NewConveyor.Scheduler, HotnessCold> where Hotness == HotnessCold {
        return flatMapLatestCold(predicate)
    }
    
    func flatMapLatest<NewConveyor: ConveyorType>(_ predicate: @escaping (Event) -> NewConveyor) -> Conveyor<NewConveyor.Event, NewConveyor.Scheduler, NewConveyor.Hotness> where Hotness == HotnessHot {
        return flatMapLatestCold(predicate)
            .convertIntoWhateverApplies()
    }
}
