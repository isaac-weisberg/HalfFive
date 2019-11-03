public struct Just<Event>: ObservableType {
    // Did I nick this naming concept from Combine? Yes i did xd

    public typealias Scheduling = AllSyncRunner

    let event: Event

    public init(_ event: Event) {
        self.event = event
    }

    public func subscribe(_ handler: @escaping (Event) -> Void) -> Disposable {
        handler(event)
        return DiposableVoid()
    }
}
