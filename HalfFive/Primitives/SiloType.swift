public protocol SiloType {
    associatedtype Event
    associatedtype Scheduler: SchedulingConst
    
    func fire(event: Event) -> Void
}
