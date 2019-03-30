public class TrashBag: Trash {
    var trash = [Trash]()
    
    func add(trash: Trash) {
        self.trash.append(trash)
    }
    
    public init() {
        
    }
}
