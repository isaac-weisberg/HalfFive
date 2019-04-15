import Dispatch

public extension ConveyorType {
    func delay<Scheduler: DeterminedScheduling>(_ time: DispatchTime, on scheduler: Scheduler) -> Conveyor<Event, Scheduler, HotnessCold> {
        let run = self.run(handler:)
        return Conveyor { handler in
            weak var weakTrash: Trash?
            let trash = run { event in
                scheduler.queue.asyncAfter(deadline: time) {
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
