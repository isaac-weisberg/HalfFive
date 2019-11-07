import Dispatch

public struct SerialDispatchQScheduler: KnownSchdulerType, SynchronizedScheduler {
    public static func instantiate() -> SerialDispatchQScheduler {
        return SerialDispatchQScheduler()
    }

    public let queue: DispatchQueue

    public init(qos: DispatchQoS = .default, label: String = "net.caroline-weisberg.sdqs") {
        self.queue = DispatchQueue(label: label, qos: qos)
    }

    init(serialQueue: DispatchQueue) {
        self.queue = serialQueue
    }
}
