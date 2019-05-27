import Dispatch

func wait(ticks: UInt, queue: DispatchQueue = DispatchQueue.main, _ handler: @escaping () -> Void) {
    var ticks = ticks
    
    func predicate() {
        queue.async {
            ticks -= 1
            if ticks < 1 {
                handler()
                return
            }
            queue.async(execute: predicate)
        }
    }
    
    predicate()
}
