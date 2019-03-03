public extension Conveyor {
    static func from(array: Array<Event>) -> Conveyor<Event, SchedulingRandom> {
        return .create { silo in
            array.forEach { silo.fire(event: $0) }
            return TrashVoid()
        }
    }
}
