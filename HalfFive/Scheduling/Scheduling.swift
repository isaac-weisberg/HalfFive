import Dispatch

public protocol SchedulingTrait {
    
}


public protocol SchedulingRandom: SchedulingTrait {
    
}


public struct SchedulingUnknown: SchedulingRandom {
    
}

public protocol DeterminedScheduling: SchedulingTrait {
    var queue: DispatchQueue { get }
}

public struct SchedulingMain: DeterminedScheduling {
    public var queue: DispatchQueue = .main
    
    public init() {
        
    }
}

public struct SchedulingSerial: DeterminedScheduling {
    public let queue: DispatchQueue = DispatchQueue(label: "net.caroline-weisberg.HalfFive.serialq")
    
    public init() {
        
    }
}
