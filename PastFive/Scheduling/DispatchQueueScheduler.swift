import Dispatch

public struct DispatchQueueScheduler: KnownSchdulerType {
    public static func == (lhs: DispatchQueueScheduler, rhs: DispatchQueueScheduler) -> Bool {
        return lhs.queue === rhs.queue
    }

    public let queue: DispatchQueue

    public init(queue: DispatchQueue) {
        self.queue = queue
    }
}
