import Dispatch

public protocol Scheduling {
    
}

protocol DeterminedScheduling: Scheduling {
    var queue: DispatchQueue { get }
}

public struct SchedulingRandom: Scheduling, SchedulingRandomOrMain {
    
}

public struct SchedulingMain: DeterminedScheduling, SchedulingRandomOrMain {
    var queue: DispatchQueue {
        return .main
    }
}

public protocol SchedulingRandomOrMain: Scheduling {
    
}

struct SchedulingSerial: DeterminedScheduling {
    var queue: DispatchQueue {
        return DispatchQueue(label: "net.caroline-weisberg.HalfFive.serialq")
    }
}
