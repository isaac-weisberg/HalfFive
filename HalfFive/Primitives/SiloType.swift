public protocol SiloType {
    associatedtype Event
    associatedtype Scheduler: Scheduling
    
    func fire(event: Event) -> Void
}
