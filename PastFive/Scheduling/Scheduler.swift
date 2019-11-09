import Dispatch

public protocol SchedulerType {

}

public protocol SingleInstanceScheduler: SchedulerType {
    static var instance: Self { get }
}

public protocol KnownSchedulerType: SchedulerType {
    var queue: DispatchQueue { get }
}

public protocol ReproduceableScheduler: KnownSchedulerType {
    static func instantiate() -> Self
}
