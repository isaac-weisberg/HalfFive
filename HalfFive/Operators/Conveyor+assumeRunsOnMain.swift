public extension SiloType where Scheduler: SchedulingRandomOrMain {
    func assumeRunsOnMain() -> Silo<Event, SchedulingMain> {
        let fire = self.fire(event:)
        return Silo { event in
            fire(event)
        }
    }
}
