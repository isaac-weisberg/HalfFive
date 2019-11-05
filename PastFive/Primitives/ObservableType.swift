public protocol ObservableType {
    associatedtype Event
    associatedtype Scheduler: SchedulerType

    var scheduler: Scheduler { get }

    func subscribe(_ handler: @escaping (Event) -> Void) -> Disposable
}
