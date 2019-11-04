import Dispatch

public struct SerialDispatchQScheduler: SerialSchedulerType {
    public static func == (lhs: SerialDispatchQScheduler, rhs: SerialDispatchQScheduler) -> Bool {
        return lhs.queue === rhs.queue
    }

    public let queue: DispatchQueue

    public init(qos: DispatchQoS = .default, label: String = "net.caroline-weisberg.sdqs") {
        self.queue = DispatchQueue(label: label, qos: qos)
    }

    init(serialQueue: DispatchQueue) {
        self.queue = serialQueue
    }
}
