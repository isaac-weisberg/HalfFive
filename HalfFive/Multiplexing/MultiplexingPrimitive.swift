protocol MultiplexingPrimitive: class, SiloType, ConveyorType {
    var predicates: [(Event) -> Void] { get set }
}

extension MultiplexingPrimitive {
    func fireAllPredicates(_ event: Event) {
        predicates.forEach { $0(event) }
    }
    
    func addPredicate(handler: @escaping (Event) -> Void) -> Trash {
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
