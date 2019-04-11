import Dispatch

public protocol Scheduling {
    
}


public protocol SchedulingRandom: Scheduling {
    
}

public protocol SchedulingHot: Scheduling {
    associatedtype Cold
}

public protocol SchedulingConst: Scheduling {
    associatedtype NonConst
}

public protocol SchedulingHotAndConst: SchedulingHot, SchedulingConst where Cold: SchedulingConst {
    
}


public struct SchedulingUnknown: SchedulingRandom {
    
}

public struct SchedulingUnknownAndSync: SchedulingRandom, SchedulingHot {
    public typealias Cold = SchedulingUnknown
}


public protocol DeterminedScheduling: SchedulingConst {
    static var queue: DispatchQueue { get }
}

public struct SchedulingMain: DeterminedScheduling, SchedulingConst {
    public typealias NonConst = SchedulingUnknown
    
    public static var queue: DispatchQueue {
        return .main
    }
}

public struct SchedulingMainOrHot: SchedulingHotAndConst, DeterminedScheduling {
    public typealias Cold = SchedulingMain
    
    public typealias NonConst = SchedulingMainOrHot
    
    public static var queue: DispatchQueue = .main
}

struct SchedulingSerial: DeterminedScheduling {
    typealias NonConst = SchedulingUnknown
    
    static var queue: DispatchQueue {
        return DispatchQueue(label: "net.caroline-weisberg.HalfFive.serialq")
    }
}
