import Dispatch

protocol MutexType {
    associatedtype Value

    func read() -> Value

    func mutate(_ actions: (inout Value) -> Void)
}

class MutexUnsafe<Value>: MutexType {
    var value: Value

    init(value: Value) {
        self.value = value
    }

    func read() -> Value {
        return value
    }

    func mutate(_ actions: (inout Value) -> Void) {
        actions(&value)
    }
}

class Mutex<Value>: MutexType {
    var value: Value

    init(value: Value) {
        self.value = value
    }

    let queue = DispatchQueue(label: "net.caroline-weisberg.mtx",
                              attributes: [DispatchQueue.Attributes.concurrent])

    func read() -> Value {
        queue.sync {
            value
        }
    }

    func mutate(_ actions: (inout Value) -> Void) {
        queue.sync(flags: .barrier) {
            actions(&value)
        }
    }
}
