public extension Conveyors {
    static func from<Event>(array: [Event]) -> Conveyor<Event, SchedulingSync> {
        return .init { handler in
            array.forEach { handler($0) }
            return TrashVoid()
        }
    }
}
