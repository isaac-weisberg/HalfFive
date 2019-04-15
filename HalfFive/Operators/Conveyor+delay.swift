import Dispatch

public extension ConveyorType {
    func delay<Scheduler: DeterminedScheduling>(_ time: DispatchTime, on scheduler: Scheduler) -> Conveyor<Event, Scheduler, HotnessCold> {
        let run = self.run(handler:)
        return Conveyor { handler in
            run { event in
                scheduler.queue.asyncAfter(deadline: time) {
                    handler(event)
                }
            }
        }
    }
}
