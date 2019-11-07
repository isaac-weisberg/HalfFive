public typealias Handler<Event> = (Event) -> Void

public typealias Subscribe<Event> = (@escaping Handler<Event>) -> Disposable
