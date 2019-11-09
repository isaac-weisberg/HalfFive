import Dispatch

public struct DispatchQueueScheduler: KnownSchedulerType {
    public let queue: DispatchQueue

    public init(queue: DispatchQueue) {
        self.queue = queue
    }
}
