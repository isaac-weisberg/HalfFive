public struct Conveyor<Event, Scheduler: Scheduling>: ConveyorType {
    public func run(silo: Silo<Event, Scheduler>) -> Trash {
        return predicate(silo)
    }
    
    let predicate: (Silo<Event, Scheduler>) -> Trash
    
    init(_ factory: @escaping (Silo<Event, Scheduler>) -> Trash) {
        self.predicate = factory
    }
    
    public static func create<Event>(factory: @escaping ((Silo<Event, SchedulingRandom>) -> Trash)) -> Conveyor<Event, SchedulingRandom> {
        return Conveyor<Event, SchedulingRandom>(factory)
    }
}
