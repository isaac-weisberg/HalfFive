import Dispatch

public struct DispatchQueueScheduler<EquityProof>: KnownSchdulerType {
    public let queue: DispatchQueue

    public init(queue: DispatchQueue) {
        self.queue = queue
    }
}
