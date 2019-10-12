public extension Observable {
    static func create(_ factory: @escaping (@escaping (Event) -> Void) -> Disposable) -> Self {
        return Self.unsafe(factory)
    }
}
