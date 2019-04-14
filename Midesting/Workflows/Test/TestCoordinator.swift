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
        let controller = testViewController(for: TestViewModelImpl(context: context))
        
        router.pushViewController(controller, animated: true)
    }
}

private extension TestCoordinator {
    func testViewController(for viewModel: TestViewModel) -> TestViewController {
        let controller = StoryboardScene.Test.testViewController.instantiate()
        
        controller.viewModel = viewModel
        
        return controller
    }
}
