extension Conveyor {
    func assumeRunsOnMain() -> Conveyor<Event, SchedulingMain> {
        let run = self.run(silo:)
        return Conveyor<Event, SchedulingMain> { silo in
            return run(Silo { event in
                silo.fire(event: event)
            })
        }
    }
}
