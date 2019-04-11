public extension SiloType where Scheduler: SchedulingHot {
    func assumeRunsOnMain() -> Silo<Event, SchedulingMain> {
        let fire = self.fire(event:)
        return Silo { event in
            fire(event)
        }
    }
}
