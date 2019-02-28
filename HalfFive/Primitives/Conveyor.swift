class Conveyor<Event, Scheduler: Scheduling>: ConveyorType {
    func run(silo: Silo<Event>) -> Trash {
        return predicate(silo)
    }
    
    let predicate: (Silo<Event>) -> Trash
    
    init(_ factory: @escaping (Silo<Event>) -> Trash) {
        self.predicate = factory
    }
    
    public static func create<Event>(factory: @escaping ((Silo<Event>) -> Trash)) -> Conveyor<Event, SchedulingRandom> {
        return Conveyor<Event, SchedulingRandom>(factory)
    }
}
