public extension Observable {
    static func deferred(_ factory: @escaping () -> Self) -> Self {
        return Self.unsafe { (handler: @escaping (Event) -> Void) -> TrashType in
            return factory()
                .subscribe(handler)
        }
    }
}
