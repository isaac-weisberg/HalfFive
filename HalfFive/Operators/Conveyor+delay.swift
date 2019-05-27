import Dispatch

public extension ConveyorType {
    func delay<Scheduler: DeterminedScheduling>(_ time: DispatchTime, on scheduler: Scheduler, ordered: Bool = true) -> Conveyor<Event, Scheduler, HotnessCold> {
        if ordered {
            return delayWithOrdering(time, on: scheduler)
        }
        return delayWithoutOrdering(time, on: scheduler)
    }
}

private extension ConveyorType {
    func delayWithoutOrdering<Scheduler: DeterminedScheduling>(_ time: DispatchTime, on scheduler: Scheduler) -> Conveyor<Event, Scheduler, HotnessCold> {
        let run = self.run(handler:)
        return .unsafe { handler in
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
    
    func delayWithOrdering<Scheduler: DeterminedScheduling>(_ time: DispatchTime, on scheduler: Scheduler) -> Conveyor<Event, Scheduler, HotnessCold> {
        let run = enumerate().run(handler:)
        return .unsafe { handler in
            weak var weakTrash: TrashWithOrdering<Event>?
            let superTrash = run { event in
                guard let trash = weakTrash else {
                    return
                }
                trash.cache[event.0] = event.1
                scheduler.queue.asyncAfter(deadline: time) {
                    guard let trash = weakTrash else {
                        return
                    }
                    trash.cache
                        .filter { $0.key <= event.0 }
                        .forEach {
                            handler($0.value)
                            trash.cache.removeValue(forKey: $0.key)
                        }
                }
            }
            let trash = TrashWithOrdering<Event>(trash: superTrash)
            weakTrash = trash
            return trash
        }
    }
}

private class TrashWithOrdering<Event>: Trash {
    var cache = [Int: Event]()
    let trash: Trash
    
    init(trash: Trash) {
        self.trash = trash
    }
}
