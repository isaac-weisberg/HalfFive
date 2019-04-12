public struct Conveyor<Event, Scheduler: Scheduling, Hotness: HotnessType>: ConveyorType {
    public func run(handler: @escaping (Event) -> Void) -> Trash {
        return predicate { event in
            handler(event)
        }
    }
    
    let predicate: (@escaping (Event) -> Void) -> Trash
    
    init(_ factory: @escaping (@escaping (Event) -> Void) -> Trash) {
        self.predicate = factory
    }
}
