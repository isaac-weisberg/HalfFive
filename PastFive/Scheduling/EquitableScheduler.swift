import Dispatch

struct EquitableScheduler<Implementation: KnownSchdulerType, EquityProof>: KnownSchdulerType, EquitableType {
    let implementation: Implementation

    var queue: DispatchQueue {
        return implementation.queue
    }

    init(implementation: Implementation, equityProof: EquityProof.Type) {
        self.implementation = implementation
    }
}

extension EquitableScheduler: SerialSchedulerType where Implementation: SerialSchedulerType {
    
}

extension KnownSchdulerType {
    func equitable<EquityProof>(by type: EquityProof.Type) -> EquitableScheduler<Self, EquityProof> {
        return EquitableScheduler(implementation: self, equityProof: type)
    }
}
