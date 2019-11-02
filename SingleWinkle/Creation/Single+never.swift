public extension Single {
    static func never() -> Self {
        return Self { _ in
            return DisposableVoid()
        }
    }
}
