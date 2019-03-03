public func ConveyorFrom<Event>(array: [Event]) -> Conveyor<Event, SchedulingRandom> {
    return .create { handler in
        array.forEach { handler($0) }
        return TrashVoid()
    }
}
