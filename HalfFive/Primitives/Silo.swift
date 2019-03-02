public class Silo<Event, Scheduler: Scheduling>: SiloType {
    typealias Subscriber = (Event) -> ()
    
    func fire(event: Event) -> Void {
        return predicate(event)
    }
    
    let predicate: (Event) -> Void
    
    public init(fire: @escaping (Event) -> Void) {
        self.predicate = fire
    }
}
