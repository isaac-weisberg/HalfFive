import Dispatch

protocol Scheduling {
    
}

protocol DeterminedScheduling: Scheduling {
    var queue: DispatchQueue { get }
}

struct SchedulingRandom: Scheduling {
    
}

struct SchedulingMain: DeterminedScheduling {
    var queue: DispatchQueue {
        return .main
    }
}

struct SchedulingGlobal: DeterminedScheduling {
    var queue: DispatchQueue {
        return .global()
    }
}
