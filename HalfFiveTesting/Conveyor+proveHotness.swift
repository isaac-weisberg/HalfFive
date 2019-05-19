import HalfFive

public extension ConveyorType where Hotness == HotnessHot {
    func proveHotness() -> Bool {
        var hot = false
        _ = run { event in
            hot = true
        }
        return hot
    }
}
