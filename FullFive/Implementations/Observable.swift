public struct Observable<Event>: ObservableType {
    static func unsafe(_ factory: @escaping (@escaping (Event) -> Void) -> TrashType) -> Self {
        return Self(factory)
    }

    let factory: (@escaping (Event) -> Void) -> TrashType

    public func subscribe(_ onNext: @escaping (Event) -> Void) -> TrashType {
        return factory(onNext)
    }

    private init(_ factory: @escaping (@escaping (Event) -> Void) -> TrashType) {
        self.factory = factory
    }
}
