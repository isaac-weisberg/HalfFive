public struct Silo<Event, Scheduler: Scheduling>: SiloType {
    typealias Predicate = (Event) -> ()
    
    func fire(event: Event) -> Void {
        return predicate(event)
    }
    
    let predicate: Predicate
    
    public init(fire: @escaping (Event) -> Void) {
        self.predicate = fire
    }
}
