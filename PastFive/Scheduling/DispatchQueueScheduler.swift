import Dispatch

public struct DispatchQueueScheduler: KnownSchdulerType {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return false
    }

    public let queue: DispatchQueue

    public init(queue: DispatchQueue) {
        self.queue = queue
    }
}
