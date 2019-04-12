public protocol SiloType {
    associatedtype Event
    associatedtype Scheduler: DeterminedScheduling
    
    func fire(event: Event) -> Void
}
