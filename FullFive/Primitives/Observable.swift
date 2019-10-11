public struct Observable<Event>: ObservableType {
    static func unsafe(_ factory: @escaping ((Event) -> Void) -> Trash) -> Self {
        return Self(factory)
    }

    let factory: ((Event) -> Void) -> Trash

    public func subscribe(_ onNext: @escaping (Event) -> Void) -> Trash {
        return factory(onNext)
    }

    private init(_ factory: @escaping ((Event) -> Void) -> Trash) {
        self.factory = factory
    }
}
