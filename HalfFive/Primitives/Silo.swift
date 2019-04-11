public struct Silo<Event, Scheduler: SchedulingConst>: SiloType {
    typealias Predicate = (Event) -> ()
    
    public func fire(event: Event) -> Void {
        return predicate(event)
    }
    
    let predicate: Predicate
    
    public init(fire: @escaping (Event) -> Void) {
        self.predicate = fire
    }
}
