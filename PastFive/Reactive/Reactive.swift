import UIKit

public struct Reactive<Base> {
    public let base: Base

    public init(_ base: Base) {
        self.base = base
    }
}

public protocol ReactiveHost {

}

public extension ReactiveHost {
    var rx: Reactive<Self> {
        return Reactive(self)
    }
}
