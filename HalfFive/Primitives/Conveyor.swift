class Conveyor<Event> {
    let run: (Silo<Event>) -> Trash
    
    init(_ factory: @escaping (Silo<Event>) -> Trash) {
        self.run = factory
    }
}
