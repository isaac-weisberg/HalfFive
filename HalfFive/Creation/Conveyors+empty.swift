public extension Conveyors {
    static func empty<Event>() -> Conveyor<Event, SchedulingUnknown, HotnessHot> {
        return Conveyor { _ in
            TrashVoid()
        }
    }
}
