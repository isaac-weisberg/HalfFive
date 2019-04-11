import Dispatch

extension Conveyor {
    func fire<Scheduler: DeterminedScheduling>(on scheduler: Scheduler) -> Conveyor<Event, Scheduler> {
        let run = self.run(handler:)
        return Conveyor<Event, Scheduler> { handler in
            run { event in
                Scheduler.queue.async {
                    handler(event)
                }
            }
        }
    }
}
