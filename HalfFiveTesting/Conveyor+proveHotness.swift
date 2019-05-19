import HalfFive

private extension ConveyorType {
    func isHot() -> Bool {
        var hot = false
        _ = run { event in
            hot = true
        }
        return hot
    }
}

public extension ConveyorType where Hotness == HotnessHot {
    func proveHotness() -> Bool {
        return isHot()
    }
}

public extension ConveyorType where Hotness == HotnessCold {
    func proveHotness() -> Bool {
        return !isHot()
    }
}
