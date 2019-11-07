public struct Observer<Event, Scheduler: SchedulerType>: ObserverType {
    public func handle(event: Event) {
        handler(event)
    }

    public let handler: (Event) -> Void

    public init(_ handler: @escaping (Event) -> Void) {
        self.handler = handler
    }
}
