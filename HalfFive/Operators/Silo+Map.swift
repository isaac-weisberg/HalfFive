public extension SiloType {
    func map<NewEvent>(_ predicate: @escaping (NewEvent) -> Event) -> Silo<NewEvent, Scheduler> {
        let fire = self.fire(event:)
        return Silo { event in
            fire(predicate(event))
        }
    }
}
