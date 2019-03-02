class Coordinator {
    var children: [Coordinator] = []
    
    func start() {
        
    }
    
    func addChild(coordinator: Coordinator) {
        children.append(coordinator)
    }
    
    func removeChild(coordinator: Coordinator) {
        children = children.filter { $0 !== coordinator }
    }
}
