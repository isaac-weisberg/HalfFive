public struct Observable<Event>: ObservableType {
    public let subscribe: Subscribe<Event>

    public init(_ subscribe: @escaping Subscribe<Event>) {
        self.subscribe = subscribe
    }
}
