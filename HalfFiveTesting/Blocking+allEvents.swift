import HalfFive
import Dispatch

class TrashWithChild<Event>: Trash {
    var stuff: [Event] = []
    var child: Trash?
    
    init() {
        
    }
}

public extension Blocking {
    func allEvents<Scheduler: DeterminedScheduling>(deadline time: DispatchTime, scheduler: Scheduler) -> Conveyor<[Base.Event], Scheduler, HotnessCold> {
        let run = base.run(handler:)
        return .unsafe { hander in
            let parentTrash = TrashWithChild<Base.Event>()
            parentTrash.child = run {[weak parentTrash] event in
                parentTrash?.stuff.append(event)
            }
            
            scheduler.queue.asyncAfter(deadline: time) {[weak parentTrash] in
                guard let parentTrash = parentTrash else {
                    return
                }
                hander(parentTrash.stuff)
            }
            
            return parentTrash
        }
    }
}
