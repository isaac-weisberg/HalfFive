public struct AsyncRunner<Scheduler: KnownSchdulerType>: SchedulingType {
    
}

extension AsyncRunner: EquitableSchedulingType where Scheduler: EquitableSchedulerType {
    public typealias EquityProof = Scheduler.EquityProof
}
