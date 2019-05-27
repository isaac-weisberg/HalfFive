public extension Conveyors {
    static func empty() -> Conveyor<Event, SchedulingUnknown, HotnessHot> {
        return Conveyor { _ in
            TrashVoid()
        }
    }
}
