public class TrashBag: Trash {
    var trash = [Trash]()
    
    public func dispose() {
        trash.forEach { $0.dispose() }
    }
    
    func add(trash: Trash) {
        self.trash.append(trash)
    }
    
    public init() {
        
    }
    
    deinit {
        dispose()
    }
}
