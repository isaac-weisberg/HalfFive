public extension Conveyors {
    static func sync(_ factory: @escaping () -> Conveyor<Event, SchedulingUnknown, HotnessHot>) -> Conveyor<Event, SchedulingUnknown, HotnessHot> {
        return .init { handler in
            factory().run(handler: handler)
        }
    }
}
