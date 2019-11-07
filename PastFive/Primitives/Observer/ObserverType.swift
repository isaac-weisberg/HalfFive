public protocol ObserverType {
    associatedtype Event

    var handler: Handler<Event> { get }
}
