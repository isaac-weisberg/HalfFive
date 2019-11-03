import Dispatch

public protocol SchedulerType {

}

public struct AnonymousScheduler: SchedulerType {
    init() { }
}

public protocol KnownSchdulerType: SchedulerType {
    associatedtype EquityProof

    var queue: DispatchQueue { get }
}
