public protocol ConveyorType {
    associatedtype Event
    associatedtype Scheduler: Scheduling
    
    func run(silo: Silo<Event, Scheduler>) -> Trash
}
