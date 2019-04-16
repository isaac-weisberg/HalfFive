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
    public static let instance = SchedulingMain()
    
    public let queue: DispatchQueue = .main
    
    private init() {
        
    }
}

public class SchedulingSerial: DeterminedScheduling {
    public static func new() -> SchedulingSerial {
        return SchedulingSerial()
    }
    
    public let queue = DispatchQueue(label: "net.caroline-weisberg.HalfFive.serialq")
    
    private init() {
        
    }
}
