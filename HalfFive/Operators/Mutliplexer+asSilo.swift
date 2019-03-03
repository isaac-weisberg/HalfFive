public extension Multiplexer {
    func asSilo() -> Silo<Event, Scheduler> {
        return Silo(fire: fire(event:))
    }
}
