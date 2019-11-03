import Dispatch

public struct DispatchQueueScheduler: KnownSchdulerType {
    public let queue: DispatchQueue

    public init(queue: DispatchQueue) {
        self.queue = queue
    }
}
