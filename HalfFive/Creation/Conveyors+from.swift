public extension Conveyors {
    static func from(array: [Event]) -> Conveyor<Event, SchedulingUnknown, HotnessHot> {
        return .unsafe { handler in
            array.forEach { handler($0) }
            return TrashVoid()
        }
    }
}
