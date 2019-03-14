public protocol Diffable {
    func isIdentical(to diffable: Self) -> Bool
}
