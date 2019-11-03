import Dispatch

struct EquitableScheduler<Implementation: KnownSchdulerType, EquityProof>: EquatableSchedulerType {
    let implementation: Implementation

    var queue: DispatchQueue {
        return implementation.queue
    }

    init(implementation: Implementation, equityProof: EquityProof.Type) {
        self.implementation = implementation
    }
}

extension KnownSchdulerType {
    func equitable<EquityProof>(by type: EquityProof.Type) -> EquitableScheduler<Self, EquityProof> {
        return EquitableScheduler(implementation: self, equityProof: type)
    }
}
