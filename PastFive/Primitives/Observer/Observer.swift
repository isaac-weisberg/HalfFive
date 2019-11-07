public struct Observer<Event>: ObserverType {
    public let handler: Handler<Event>

    init(_ handler: @escaping Handler<Event>) {
        self.handler = handler
    }
}
