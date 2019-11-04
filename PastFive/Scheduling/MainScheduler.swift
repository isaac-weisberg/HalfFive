import Dispatch

public struct MainScheduler: SerialSchedulerType, EquitableType {
    public static func == (lhs: MainScheduler, rhs: MainScheduler) -> Bool {
        return lhs.nestedScheduler == rhs.nestedScheduler
    }

    public enum EquityProof { }

    let nestedScheduler = SerialDispatchQScheduler(serialQueue: .main)

    public var queue: DispatchQueue {
        return nestedScheduler.queue
    }

    public init() {

    }
}
