import Foundation

public extension ConveyorType {
    func run<RunScheduler: DeterminedScheduling>(on scheduler: RunScheduler) -> Conveyor<Event, Scheduler, HotnessCold> {
        let run = self.run(handler:)
        return Conveyor { handler in
            let trash = TrashDeferred()
            scheduler.queue.async {
                trash.trash = run(handler)
            }
            return trash
        }
    }
}
