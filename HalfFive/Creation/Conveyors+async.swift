public extension Conveyors {
    static func async(_ factory: @escaping (@escaping (Event) -> Void) -> Trash) -> Conveyor<Event, SchedulingUnknown, HotnessCold> {
        return Conveyor(factory)
    }
}
