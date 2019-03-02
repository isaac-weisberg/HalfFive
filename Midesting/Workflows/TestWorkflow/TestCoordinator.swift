import UIKit

class TestCoordinator: Coordinator {
    typealias Context = AppContext
    typealias Router = UINavigationController
    
    let router: Router
    let context: Context
    
    init(router: Router, context: Context) {
        self.router = router
        self.context = context
    }
    
    override func start() {
        
    }
}

private extension TestCoordinator {
    func testViewController() -> TestViewController {
        let controller = StoryboardScene.Test.testViewController.instantiate()
        
        return controller
    }
}
