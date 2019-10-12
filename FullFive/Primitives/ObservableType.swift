public protocol ObservableType {
    associatedtype Event

    func subscribe(_ onNext: @escaping (Event) -> Void) -> TrashType
}

public extension ObservableType {
    func subscribe<Observer: ObserverType>(to observer: Observer) -> TrashType where Observer.Event == Event {
        return subscribe(observer.onNext)
    }
}
