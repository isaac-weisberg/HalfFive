public extension Observable {
    static func create(_ factory: @escaping ((Event) -> Void) -> TrashType) -> Self {
        return Self.unsafe(factory)
    }
}
