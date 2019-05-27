import HalfFive

public extension Blocking {
    func isHot() -> Bool {
        var hot = false
        _ = base.run { event in
            hot = true
        }
        return hot
    }
}

public extension Blocking where Base.Hotness == HotnessHot {
    func proveHotness() -> Bool {
        return isHot()
    }
}

public extension Blocking where Base.Hotness == HotnessCold {
    func proveHotness() -> Bool {
        return !isHot()
    }
}
