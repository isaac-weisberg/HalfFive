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
    public var queue: DispatchQueue {
        return .main
    }
    
    public init() {
        
    }
}

public struct SchedulingSerial: DeterminedScheduling {
    public var queue: DispatchQueue {
        return DispatchQueue(label: "net.caroline-weisberg.HalfFive.serialq", attributes: [])
    }
    
    public init() {
        
    }
}

internal struct SchedulingLiterallyAny: DeterminedScheduling, SchedulingRandom {
    var queue: DispatchQueue {
        return DispatchQueue.main
    }
    
    
}
