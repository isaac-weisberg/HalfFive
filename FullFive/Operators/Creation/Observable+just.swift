public extension Observable {
    static func just(_ event: Event) -> Self {
        return Self.unsafe { handler in
            handler(event)

            return Trash.void()
        }
    }
}
