public extension Trash {
    func disposed(by trashBag: TrashBag) {
        trashBag.add(trash: self)
    }
}
