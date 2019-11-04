import Dispatch

public protocol SchedulerType: Equatable {

}

public struct AllSyncScheduler: SchedulerType, EquitableType, Equatable {
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

public protocol SerialSchedulerType: KnownSchdulerType {
    
}
