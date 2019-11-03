import Dispatch

public struct MainScheduler: EquatableSchedulerType {
    public enum EquityProof { }

    let nestedScheduler = SerialDispatchQScheduler(serialQueue: .main)

    public var queue: DispatchQueue {
        return nestedScheduler.queue
    }

    public init() {

    }
}
