public struct Conveyor<Event, Scheduler: Scheduling>: ConveyorType {
    public func run(handler: @escaping (Event) -> Void) -> Trash {
        return predicate { event in
            handler(event)
        }
    }
    
    let predicate: (@escaping (Event) -> Void) -> Trash
    
    init(_ factory: @escaping (@escaping (Event) -> Void) -> Trash) {
        self.predicate = factory
    }
    
    public static func create<Event>(factory: @escaping ((Event) -> Void) -> Trash) -> Conveyor<Event, SchedulingRandom> {
        return Conveyor<Event, SchedulingRandom>(factory)
    }
}
