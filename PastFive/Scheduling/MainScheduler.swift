import Dispatch

public struct MainScheduler: KnownSchdulerType {
    public enum EquityProof { }

    let nestedScheduler = SerialDispatchQScheduler<EquityProof>(serialQueue: .main)

    public var queue: DispatchQueue {
        return nestedScheduler.queue
    }

    public init() {

    }
}
