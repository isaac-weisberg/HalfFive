import Dispatch

extension Conveyor {
    func fire<Scheduler: DeterminedScheduling>(on scheduler: Scheduler) -> Conveyor<Event, Scheduler> {
        let run = self.run(silo:)
        return Conveyor<Event, Scheduler> { silo in
            run(Silo { event in
                scheduler.queue.async {
                    silo.fire(event: event)
                }
            })
        }
    }
}
