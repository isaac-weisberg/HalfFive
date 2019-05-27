public extension Conveyors {
    static func just(_ event: Event) -> Conveyor<Event, SchedulingUnknown, HotnessHot> {
        return .unsafe { handler in
            handler(event)
            return TrashVoid()
        }
    }
}
