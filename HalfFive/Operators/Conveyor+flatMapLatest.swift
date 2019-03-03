extension Conveyor {
    func flatMapLatest<NewEvent>(predicate: @escaping (Event) -> Conveyor<NewEvent, Scheduler>) -> Conveyor<NewEvent, Scheduler> {
        let run = self.run(handler:)
        return Conveyor<NewEvent, Scheduler> { handler in
            let composite = TrashCompositeTwo(primary: nil, secondary: nil)
            composite.primary = run { event in
                composite.secondary?.dispose()
                let newConveyor = predicate(event)
                composite.secondary = newConveyor.run { event in
                    handler(event)
                }
            }
            return composite
        }
    }
}
