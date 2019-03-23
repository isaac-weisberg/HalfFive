public class Multiplexer<Event>: SiloType, ConveyorType {
    public typealias Scheduler = SchedulingRandom
    
    private(set) var predicates: [(Event) -> Void] = []
    
    public init() {
        
    }
    
    public func fire(event: Event) {
        predicates.forEach { $0(event) }
    }
    
    public func run(handler: @escaping (Event) -> Void) -> Trash {
        var subscribers = self.predicates
        subscribers.append(handler)
        self.predicates = subscribers
        return TrashAbstract {[weak self] in
            guard let self = self else {
                return
            }
            self.predicates = self.predicates.filter { ($0 as AnyObject) !== (handler as AnyObject) }
        }
    }
}
