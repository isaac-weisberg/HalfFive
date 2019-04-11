import Foundation

public extension ConveyorType where Scheduler: SchedulingRandom {
    func run<RunScheduler: DeterminedScheduling>(on scheduler: RunScheduler.Type) -> Conveyor<Event, Scheduler> {
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

public extension Conveyor where Scheduler: SchedulingHot {
    func run<RunScheduler: DeterminedScheduling>(on scheduler: RunScheduler.Type) -> Conveyor<Event, Scheduler.Cold> {
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
