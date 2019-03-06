import UIKit

let testData = TestModel(
    questions: [
        (title:"How to eat me a burger?", selection: .single, answers: [(id: "a", "With mouth")]),
        (title:"Where to buy MGSV?", selection: .multiple,answers: [(id: "f","GameStop"), (id: "as", "PlayMarket"), (id: "fof","FUck off"), (id: "a", "With mouth"), (id: "load","dfgsny\naebrqebtbt bwrtb wtrb\nqerg qeh trh\n werg 145g\n qbtwbt")]),
        (title:"Can you stop this please?", selection: .single, answers: [(id: "fof","FUck off")]),
        (title:"How to ass?", selection: .single, answers: [(id: "load","dfgsny\naebrqebtbt bwrtb wtrb\nqerg qeh trh\n werg 145g\n qbtwbt")])
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
