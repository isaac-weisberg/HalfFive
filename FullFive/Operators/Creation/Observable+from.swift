public extension Observable {
    static func from(_ events: [Event]) -> Self {
        return Self.unsafe { handler in
            events.forEach { event in
                handler(event)
            }

            return Disposables.create()
        }
    }
}
