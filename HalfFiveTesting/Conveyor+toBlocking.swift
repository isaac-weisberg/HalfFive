import HalfFive

public struct Blocking<Base: ConveyorType> {
    let base: Base
    
    init(base: Base){
        self.base = base
    }
}

public extension ConveyorType {
    func toBlocking() -> Blocking<Self> {
        return Blocking(base: self)
    }
}
