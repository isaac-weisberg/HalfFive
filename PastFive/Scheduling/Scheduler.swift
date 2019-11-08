import Dispatch

public protocol SchedulerType {

}

public protocol SingleInstanceScheduler: SchedulerType {
    static var instance: Self { get }
}

public protocol KnownSchdulerType: SchedulerType {
    var queue: DispatchQueue { get }
}

public protocol ReproduceableScheduler: KnownSchdulerType {
    static func instantiate() -> Self
}
