public extension ConveyorType {
    func fire<Scheduler: DeterminedScheduling>(on scheduler: Scheduler) -> Conveyor<Event, Scheduler, HotnessCold> {
        let run = self.run(handler:)
        return .unsafe { handler in
            return run { event in
                scheduler.queue.async {
                    handler(event)
                }
            }
        }
    }
}
