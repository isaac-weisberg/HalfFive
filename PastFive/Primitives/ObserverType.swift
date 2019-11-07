public protocol ObserverType {
    associatedtype Event
    associatedtype Scheduler: SchedulerType

    func handle(event: Event)
}
