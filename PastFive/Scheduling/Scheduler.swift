import Dispatch

public protocol SchedulerType {

}

public struct AllSyncScheduler: SchedulerType, EquitableType {
    public enum EquityProof { }
}

public struct RandomScheduler: SchedulerType {
    
}

public protocol KnownSchdulerType: SchedulerType {
    var queue: DispatchQueue { get }
}

public protocol SerialSchedulerType: KnownSchdulerType {
    
}
