import Dispatch

public struct MainScheduler: KnownSchdulerType {
    let nestedScheduler = SerialDispatchQScheduler(serialQueue: .main)

    public var queue: DispatchQueue {
        return nestedScheduler.queue
    }

    public init() {

    }
}
