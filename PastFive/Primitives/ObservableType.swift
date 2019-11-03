public protocol ObservableType {
    associatedtype Event
    associatedtype Scheduling: SchedulingType

    func subscribe(_ handler: @escaping (Event) -> Void) -> Disposable
}
