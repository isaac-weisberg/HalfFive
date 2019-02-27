import Dispatch

class TrashDeferred: Trash {
    private var trash: Trash?
    private var disposed: Bool = false
    private let semaphore = DispatchSemaphore(value: 1)
    
    init() {
        
    }
    
    func update(with trash: Trash) {
        semaphored {
            if disposed {
                trash.dispose()
            } else {
                self.trash = trash
            }
        }
    }
    
    func dispose() {
        semaphored {
            if disposed {
                return
            }
            trash?.dispose()
            disposed = true
            trash = nil
        }
    }
}

private extension TrashDeferred {
    func semaphored(block: () -> Void) {
        semaphore.wait()
        block()
        semaphore.signal()
    }
}
