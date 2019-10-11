public protocol ObserverType {
    associatedtype Event

    func onNext(_ event: Event)
}
