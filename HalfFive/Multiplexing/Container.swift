public class Container<Event, Scheduler: DeterminedScheduling>: MultiplexingPrimitive {
    public typealias Hotness = HotnessHot
    
    public private(set) var value: Event
    
    var predicates: [(Event) -> Void] = []
    
    public init(value: Event) {
        self.value = value
    }
    
    public func fire(event: Event) {
        fireAllPredicates(event)
        value = event
    }
    
    public func run(handler: @escaping (Event) -> Void) -> Trash {
        let trash = addPredicate(handler: handler)
        handler(value)
        return trash
    }
}
