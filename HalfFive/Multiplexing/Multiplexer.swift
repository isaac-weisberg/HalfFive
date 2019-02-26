class Multiplexer<Event>: SiloType, ConveyorType {
    private(set) var subscribers: [Silo<Event>] = []
    
    init() {
        
    }
    
    func fire(event: Event) {
        subscribers.forEach { $0.fire(event: event) }
    }
    
    func run(silo: Silo<Event>) -> Trash {
        var subscribers = self.subscribers
        subscribers.append(silo)
        self.subscribers = subscribers
        return TrashAbstract {[weak self] in
            guard let self = self else {
                return
            }
            self.subscribers = self.subscribers.filter { $0 !== silo }
        }
    }
}
