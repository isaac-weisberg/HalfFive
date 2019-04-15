public extension ConveyorType {
    func fire<Scheduler: DeterminedScheduling>(on scheduler: Scheduler) -> Conveyor<Event, Scheduler, HotnessCold> {
        let run = self.run(handler:)
        return .init { handler in
            weak var weakTrash: Trash?
            let trash = run { event in
                scheduler.queue.async {
                    guard weakTrash != nil else {
                        return
                    }
                    handler(event)
                }
            }
            weakTrash = trash
            return trash
        }
    }
}
