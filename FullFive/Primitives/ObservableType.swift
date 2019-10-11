public protocol ObservableType {
    associatedtype Event

    func subscribe(_ onNext: @escaping (Event) -> Void) -> Trash
}

public extension ObservableType {
    func subscribe<Observer: ObserverType>(to observer: Observer) -> Trash where Observer.Event == Event {
        return subscribe(observer.onNext)
    }
}
