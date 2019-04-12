import Dispatch

extension Conveyor {
    func fire<Scheduler: DeterminedScheduling>(on scheduler: Scheduler) -> Conveyor<Event, Scheduler, HotnessCold> {
        let run = self.run(handler:)
        return .init { handler in
            run { event in
                scheduler.queue.async {
                    handler(event)
                }
            }
        }
    }
}
