public protocol ObservableType {
    associatedtype Event

    func subscribe(_ onNext: @escaping (Event) -> Void) -> Disposable
}

public extension ObservableType {
    func subscribe<Observer: ObserverType>(to observer: Observer) -> Disposable where Observer.Event == Event {
        return subscribe(observer.onNext)
    }
}
