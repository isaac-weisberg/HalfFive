public struct Conveyor<Event, Scheduler: SchedulingTrait, Hotness: HotnessTrait>: ConveyorType {
    public static func unsafe(_ factory: @escaping (@escaping (Event) -> Void) -> Trash) -> Conveyor {
        return Conveyor(factory)
    }
    
    public func run(handler: @escaping (Event) -> Void) -> Trash {
        return predicate { event in
            handler(event)
        }
    }
    
    let predicate: (@escaping (Event) -> Void) -> Trash
    
    private init(_ factory: @escaping (@escaping (Event) -> Void) -> Trash) {
        self.predicate = factory
    }
}
