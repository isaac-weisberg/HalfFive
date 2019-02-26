class TrashAbstract: Trash {
    func dispose() {
        return predicate()
    }
    
    let predicate: () -> Void
    
    init(predicate: @escaping () -> Void) {
        self.predicate = predicate
    }
}
