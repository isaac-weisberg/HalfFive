extension Conveyor {
    func flatMapLatest<NewEvent>(predicate: @escaping (Event) -> Conveyor<NewEvent, Scheduler>) -> Conveyor<NewEvent, Scheduler> {
        let run = self.run(silo:)
        return Conveyor<NewEvent, Scheduler> { silo in
            let composite = TrashCompositeTwo(primary: nil, secondary: nil)
            composite.primary = run(Silo { event in
                composite.secondary?.dispose()
                let newConveyor = predicate(event)
                composite.secondary = newConveyor.run(silo: Silo { event in
                    silo.fire(event: event)
                })
            })
            return composite
        }
    }
}
