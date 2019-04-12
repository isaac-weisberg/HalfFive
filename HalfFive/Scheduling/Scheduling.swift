import Dispatch

public protocol Scheduling {
    
}


public protocol SchedulingRandom: Scheduling {
    
}


public struct SchedulingUnknown: SchedulingRandom {
    
}

public protocol DeterminedScheduling: Scheduling {
    var queue: DispatchQueue { get }
}

public struct SchedulingMain: DeterminedScheduling {
    public var queue: DispatchQueue {
        return .main
    }
    
    public init() {
        
    }
}

public struct SchedulingSerial: DeterminedScheduling {
    public var queue: DispatchQueue {
        return DispatchQueue(label: "net.caroline-weisberg.HalfFive.serialq")
    }
    
    public init() {
        
    }
}
