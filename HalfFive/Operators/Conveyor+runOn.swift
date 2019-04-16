public extension ConveyorType {
    internal func runInternal<RunScheduler: DeterminedScheduling>(on scheduler: RunScheduler) -> Conveyor<Event, RunScheduler, HotnessCold> {
        let run = self.run(handler:)
        return Conveyor { handler in
            let trash = TrashDeferred()
            scheduler.queue.async {
                trash.trash = run(handler)
            }
            return trash
        }
    }
    
    func run<RunScheduler: DeterminedScheduling>(on scheduler: RunScheduler) -> Conveyor<Event, RunScheduler, HotnessCold> where Hotness == HotnessHot {
        return runInternal(on: scheduler)
    }
    
    func run<RunScheduler: DeterminedScheduling>(on scheduler: RunScheduler) -> Conveyor<Event, Scheduler, HotnessCold> where Hotness == HotnessCold {
        let run = runInternal(on: scheduler).run(handler:)
        return Conveyor { handler in
            run(handler)
        }
    }
}
