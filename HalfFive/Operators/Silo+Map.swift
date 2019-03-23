public extension SiloType {
    func map<OldEvent>(_ predicate: @escaping (OldEvent) -> Event) -> Silo<OldEvent, Scheduler> {
        let fire = self.fire(event:)
        return Silo { event in
            fire(predicate(event))
        }
    }
}
