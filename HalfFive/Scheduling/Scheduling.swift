import Dispatch

public protocol Scheduling {
    
}

//public protocol SchedulingRandom: Scheduling {
//
//}

public struct SchedulingUnknown: Scheduling {
    
}


public protocol SchedulingHot: Scheduling {
    
}

public protocol SchedulingCold: Scheduling {
    
}



public protocol SchedulingConst: Scheduling {
    
}

public protocol SchedulingColdConst: SchedulingConst {
    typealias NoConst = SchedulingCold
}

public protocol SchedulingHotConst: SchedulingHot, SchedulingConst {
    typealias NoConst = SchedulingHot
}

public protocol SchedulingHotImpure: SchedulingHot {
    associatedtype NoHot: SchedulingConst
}

public struct SchedulingSync: SchedulingHot, SchedulingConst {
    
}


protocol DeterminedScheduling: SchedulingConst {
    static var queue: DispatchQueue { get }
}

public struct SchedulingMain: DeterminedScheduling {
    static var queue: DispatchQueue {
        return .main
    }
}

public struct SchedulingMainOrHot: SchedulingHotImpure, SchedulingConst {
    public typealias NoHot = SchedulingMain
}

struct SchedulingSerial: DeterminedScheduling {
    static var queue: DispatchQueue {
        return DispatchQueue(label: "net.caroline-weisberg.HalfFive.serialq")
    }
}
