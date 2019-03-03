import UIKit

let testData = TestModel(
    questions: [
        (title:"How to eat me a burger?", identity: "asdfvrv"),
        (title:"Where to buy MGSV?", identity: "asdfvrasbdear"),
        (title:"Can you stop this please?", identity: "asdfvrassbdear"),
        (title:"How to ass?", identity: "dfgsny")
    ]
)

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
        let controller = testViewController(for: TestViewModelImpl(data: testData))
        
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
