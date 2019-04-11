public extension Conveyors {
    static func sync<Event>(_ factory: @escaping () -> Conveyor<Event, SchedulingSync>) -> Conveyor<Event, SchedulingSync> {
        return .init { handler in
            factory().run(handler: handler)
        }
    }
}
