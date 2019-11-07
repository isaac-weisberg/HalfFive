import Dispatch

public protocol SchedulerType: Equatable {

}

public protocol KnownSchdulerType: SchedulerType {
    var queue: DispatchQueue { get }
}

extension SchedulerType where Self: KnownSchdulerType {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.queue === rhs.queue
    }
}

public protocol SynchronizedScheduler: SchedulerType {
    static func instantiate() -> Self
}
