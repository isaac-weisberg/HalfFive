public class Multiplexer<Event, Scheduler: DeterminedScheduling>: MultiplexingPrimitive {
    public typealias Hotness = HotnessCold
    
    var predicates: [(Event) -> Void] = []
    
    public init() {
        
    }
    
    public func fire(event: Event) {
        fireAllPredicates(event)
    }
    
    public func run(handler: @escaping (Event) -> Void) -> Trash {
        return addPredicate(handler: handler)
    }
}
