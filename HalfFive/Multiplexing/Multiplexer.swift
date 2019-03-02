public class Multiplexer<Event, Scheduler: Scheduling>: SiloType, ConveyorType {
    private(set) var predicates: [Silo<Event, Scheduler>.Predicate] = []
    
    init() {
        
    }
    
    func fire(event: Event) {
        predicates.forEach { $0(event) }
    }
    
    public func run(silo: Silo<Event, Scheduler>) -> Trash {
        var subscribers = self.predicates
        let predicate = silo.predicate
        subscribers.append(predicate)
        self.predicates = subscribers
        return TrashAbstract {[weak self] in
            guard let self = self else {
                return
            }
            self.predicates = self.predicates.filter { ($0 as AnyObject) !== (predicate as AnyObject) }
        }
    }
}
