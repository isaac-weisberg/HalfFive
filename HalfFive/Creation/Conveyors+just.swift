public extension Conveyors {
    static func just<Event>(_ event: Event) -> Conveyor<Event, SchedulingUnknown, HotnessHot> {
        return Conveyor { handler in
            handler(event)
            return TrashVoid()
        }
    }
}
