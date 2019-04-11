public extension Conveyors {
    static func sync<Event>(_ factory: @escaping () -> Conveyor<Event, SchedulingUnknownAndSync>) -> Conveyor<Event, SchedulingUnknownAndSync> {
        return .init { handler in
            factory().run(handler: handler)
        }
    }
}
