public extension Container {
    func asSilo() -> Silo<Event, Scheduler> {
        return Silo(fire: fire(event:))
    }
}

public extension Multiplexer {
    func asSilo() -> Silo<Event, Scheduler> {
        return Silo(fire: fire(event:))
    }
}
