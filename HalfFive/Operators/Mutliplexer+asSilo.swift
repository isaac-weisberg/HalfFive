public extension Multiplexer where Scheduler: SchedulingHotAndConst {
    func asSilo() -> Silo<Event, Scheduler.Cold> {
        return Silo(fire: fire(event:))
    }
}

public extension Multiplexer {
    func asSilo() -> Silo<Event, Scheduler> {
        return Silo(fire: fire(event:))
    }
}
