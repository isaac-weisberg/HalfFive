import Dispatch

public protocol Scheduling {
    
}

public protocol SchedulingRandom: Scheduling {
    
}

public struct SchedulingUnknown: SchedulingRandom {
    
}

public protocol SchedulingConst: Scheduling {
    
}

public protocol SchedulingHot: SchedulingConst {
    
}

public protocol SchedulingHotImpure: SchedulingHot {
    associatedtype NoHot: SchedulingConst
}

public struct SchedulingSync: SchedulingHot {
    
}


protocol DeterminedScheduling: SchedulingConst {
    static var queue: DispatchQueue { get }
}

public struct SchedulingMain: DeterminedScheduling {
    static var queue: DispatchQueue {
        return .main
    }
}

public struct SchedulingMainOrHot: SchedulingHotImpure, SchedulingRandom {
    public typealias NoHot = SchedulingMain
}

struct SchedulingSerial: DeterminedScheduling {
    static var queue: DispatchQueue {
        return DispatchQueue(label: "net.caroline-weisberg.HalfFive.serialq")
    }
}
