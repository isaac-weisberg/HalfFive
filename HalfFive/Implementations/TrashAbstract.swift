public class TrashAbstract: Trash {
    let predicate: () -> Void
    
    public init(predicate: @escaping () -> Void) {
        self.predicate = predicate
    }
    
    deinit {
        predicate()
    }
}
