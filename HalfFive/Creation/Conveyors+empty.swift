public extension Conveyors {
    static func empty() -> Conveyor<Event, SchedulingUnknown, HotnessHot> {
        return .unsafe { _ in
            TrashVoid()
        }
    }
}
