public struct Observer<Event>: ObserverType {
    let handler: (Event) -> Void

    public func onNext(_ event: Event) {
        handler(event)
    }

    public init(_ handler: @escaping (Event) -> Void) {
        self.handler = handler
    }
}
