public extension ConveyorType {
    func filterNil<Wrapped>() -> Conveyor<Wrapped, Scheduler, Hotness> where Event == Optional<Wrapped> {
        return self
            .filter { $0 != nil }
            .map { $0! }
    }
}
