struct Silo<Event> {
    let fire: (Event) -> Void
    
    init(fire: @escaping (Event) -> Void) {
        self.fire = fire
    }
}
