import Dispatch

public protocol Scheduling {
    
}

protocol DeterminedScheduling: Scheduling {
    var queue: DispatchQueue { get }
}

public struct SchedulingRandom: Scheduling {
    
}

public struct SchedulingMain: DeterminedScheduling {
    var queue: DispatchQueue {
        return .main
    }
}

struct SchedulingSerial: DeterminedScheduling {
    var queue: DispatchQueue {
        return DispatchQueue(label: "net.caroline-weisberg.HalfFive.serialq")
    }
}
