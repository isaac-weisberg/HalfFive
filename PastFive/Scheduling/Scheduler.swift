import Dispatch

public protocol SchedulerType: Equatable {

}

public struct AllSyncScheduler: SchedulerType {
    public static func == (lhs: AllSyncScheduler, rhs: AllSyncScheduler) -> Bool {
        return true
    }

    public enum EquityProof { }
}

public struct RandomScheduler: SchedulerType {
    public static func == (lhs: RandomScheduler, rhs: RandomScheduler) -> Bool {
        return false
    }
}

public protocol KnownSchdulerType: SchedulerType {
    var queue: DispatchQueue { get }
}

extension SchedulerType where Self: KnownSchdulerType {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.queue === rhs.queue
    }
}

public protocol SerialSchedulerType: KnownSchdulerType {
    
}
