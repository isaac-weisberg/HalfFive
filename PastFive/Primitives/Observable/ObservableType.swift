public protocol ObservableType {
    associatedtype Event

    var subscribe: Subscribe<Event> { get }
}
