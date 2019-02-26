protocol SiloType {
    associatedtype Event
    
    func fire(event: Event) -> Void
}
