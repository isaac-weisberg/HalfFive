import Dispatch

public struct MainScheduler: KnownSchdulerType, SynchronizedScheduler {
    public static func == (lhs: MainScheduler, rhs: MainScheduler) -> Bool {
        return lhs.nestedScheduler == rhs.nestedScheduler
    }

    let nestedScheduler = SerialDispatchQScheduler(serialQueue: .main)

    public var queue: DispatchQueue {
        return nestedScheduler.queue
    }

    public init() {

    }
}
