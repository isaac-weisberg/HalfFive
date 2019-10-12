public extension Observable {
    static func deferred(_ factory: @escaping () -> Self) -> Self {
        return Self.unsafe { (handler: @escaping (Event) -> Void) -> Disposable in
            return factory()
                .subscribe(handler)
        }
    }
}
