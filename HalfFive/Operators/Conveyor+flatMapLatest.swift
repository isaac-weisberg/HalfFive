extension Conveyor {
    func flatMapLatest<NewEvent>(predicate: @escaping (Event) -> Conveyor<NewEvent>) -> Conveyor<NewEvent> {
        let run = self.run
        return Conveyor<NewEvent> { silo in
            let composite = TrashCompositeTwo(primary: nil, secondary: nil)
            composite.primary = run(Silo { event in
                composite.secondary?.dispose()
                let newConveyor = predicate(event)
                composite.secondary = newConveyor.run(Silo { event in
                    silo.fire(event)
                })
            })
            return composite
        }
    }
}
