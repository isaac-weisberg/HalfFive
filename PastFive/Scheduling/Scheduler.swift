import Dispatch

public protocol SchedulerType {

}

public struct AnonymousScheduler: SchedulerType {
    init() { }
}

public protocol KnownSchdulerType: SchedulerType {
    var queue: DispatchQueue { get }
}
