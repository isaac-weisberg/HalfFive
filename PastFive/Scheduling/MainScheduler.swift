import Dispatch

public struct MainScheduler: SerialSchedulerType, EquitableType {
    public enum EquityProof { }

    let nestedScheduler = SerialDispatchQScheduler(serialQueue: .main)

    public var queue: DispatchQueue {
        return nestedScheduler.queue
    }

    public init() {

    }
}
