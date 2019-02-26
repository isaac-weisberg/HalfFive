protocol ConveyorType {
    associatedtype Event
    
    func run(silo: Silo<Event>) -> Trash
}
