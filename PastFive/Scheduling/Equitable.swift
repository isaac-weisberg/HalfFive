import Dispatch

public struct Equitable<Scheduler: KnownSchdulerType, EquityProof>: KnownSchdulerType, EquitableType {
    let scheduler: Scheduler

    public var queue: DispatchQueue {
        return scheduler.queue
    }

    public init(_ scheduler: Scheduler, _ equityProof: EquityProof.Type) {
        self.scheduler = scheduler
    }
}

extension Equitable: SerialSchedulerType where Scheduler: SerialSchedulerType {
    
}
