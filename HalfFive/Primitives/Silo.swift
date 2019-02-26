class Silo<Event>: SiloType {
    func fire(event: Event) -> Void {
        return predicate(event)
    }
    
    let predicate: (Event) -> Void
    
    init(fire: @escaping (Event) -> Void) {
        self.predicate = fire
    }
}
