public extension ConveyorType {
    func flatMapLatest<NewConveyor: ConveyorType>(predicate: @escaping (Event) -> NewConveyor) -> Conveyor<NewConveyor.Event, NewConveyor.Scheduler, NewConveyor.Hotness> {
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
}
