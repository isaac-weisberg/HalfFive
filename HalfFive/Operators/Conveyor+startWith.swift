public extension ConveyorType where Scheduler == SchedulingMain {
    func startWith(event: Event) -> Conveyor<Event, SchedulingMainOrHot> {
        let run = self.run(handler:)
        return Conveyor { handler in
            handler(event)
            return run(handler)
        }
    }
}
