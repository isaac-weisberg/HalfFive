class Multiplexer<Event> {
    var subscribers: [Silo<Event>] = []
    
    init() {
        
    }
}

extension Multiplexer: SiloType {
    func fire(event: Event) {
        subscribers.forEach { $0.fire(event: event) }
    }
}

extension Multiplexer: ConveyorType {
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
