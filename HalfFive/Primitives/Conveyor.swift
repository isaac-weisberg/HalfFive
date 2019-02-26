class Conveyor<Event>: ConveyorType {
    func run(silo: Silo<Event>) -> Trash {
        return predicate(silo)
    }
    
    let predicate: (Silo<Event>) -> Trash
    
    init(_ factory: @escaping (Silo<Event>) -> Trash) {
        self.predicate = factory
    }
}
