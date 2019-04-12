public protocol ConveyorType {
    associatedtype Event
    associatedtype Scheduler: SchedulingTrait
    associatedtype Hotness: HotnessTrait
    
    func run(handler: @escaping (Event) -> Void) -> Trash
}

public extension ConveyorType {
    func run<Silo: SiloType>(silo: Silo) -> Trash where Silo.Event == Event, Silo.Scheduler == Scheduler {
        return run(handler: silo.fire(event:))
    }
}
