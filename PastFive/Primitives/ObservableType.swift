public protocol ObservableType {
    associatedtype Event
    associatedtype Scheduler: SchedulerType

    var scheduler: Scheduler { get }

    func subscribe(_ handler: @escaping (Event) -> Void) -> Disposable
}

public protocol EquitablyScheduledObservableType: ObservableType where Scheduler: EquitableType {

}
