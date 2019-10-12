public struct Trash {

}

public class TrashVoid: TrashType {

}

public extension Trash {
    static func void() -> TrashVoid {
        return TrashVoid()
    }
}
