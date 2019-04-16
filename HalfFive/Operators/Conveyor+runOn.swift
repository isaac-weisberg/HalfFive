public extension ConveyorType {
    internal func runInternal<RunScheduler: DeterminedScheduling>(on scheduler: RunScheduler) -> Conveyor<Event, RunScheduler, HotnessCold> {
        let run = self.run(handler:)
        return Conveyor { handler in
            let trash = TrashDeferred()
            weak var weakTrash = trash
            scheduler.queue.async {
                guard let trash = weakTrash else {
                    return
                }
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
