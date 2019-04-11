public extension Multiplexer where Scheduler: SchedulingHotImpure {
    func asSilo() -> Silo<Event, Scheduler.NoHot> {
        return Silo(fire: fire(event:))
    }
}

public extension Multiplexer {
    func asSilo() -> Silo<Event, Scheduler> {
        return Silo(fire: fire(event:))
    }
}
