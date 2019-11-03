public protocol ObservableType {
    associatedtype Event
    associatedtype Scheduler: SchedulerType

    func subscribe(_ handler: @escaping (Event) -> Void) -> Disposable
}

public protocol EquitablyScheduledObservableType: ObservableType where Scheduler: EquitableType {

}
