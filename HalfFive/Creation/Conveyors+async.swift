public extension Conveyors {
    static func async<Event>(_ factory: @escaping (@escaping (Event) -> Void) -> Trash) -> Conveyor<Event, SchedulingUnknown, HotnessHot> {
        return Conveyor(factory)
    }
}