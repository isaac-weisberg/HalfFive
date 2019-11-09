import Dispatch

public struct DispatchQueueScheduler: KnownSchedulerType {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return false
    }

    public let queue: DispatchQueue

    public init(queue: DispatchQueue) {
        self.queue = queue
    }
}
