import PastFive
import UIKit

struct Reactive<Base> {
    let base: Base

    init(_ base: Base) {
        self.base = base
    }
}

protocol ReactiveHost {

}

extension ReactiveHost {
    var rx: Reactive<Self> {
        return Reactive(self)
    }
}
