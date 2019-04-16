public extension ConveyorType {
    func fire<Scheduler: DeterminedScheduling>(on scheduler: Scheduler) -> Conveyor<Event, Scheduler, HotnessCold> {
        let run = self.run(handler:)
        return Conveyor { handler in
            var `init` = false
            weak var weakTrash: Trash?
            let trash = run { event in
                scheduler.queue.async {
                    if !`init`, weakTrash == nil {
                        return
                    }
                    
                    handler(event)
                }
            }
            `init` = true
            weakTrash = trash
            return trash
        }
    }
}
