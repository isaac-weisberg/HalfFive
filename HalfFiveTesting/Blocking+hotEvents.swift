import HalfFive

public extension Blocking {
    func hotEvents() -> [Base.Event] {
        var events = [Base.Event]()
        _ = base.run { event in
            events.append(event)
        }
        return events
    }
}
