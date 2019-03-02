import UIKit

class MainCoordinator: Coordinator {
    typealias Router = UIWindow
    typealias Context = AppContext
    
    let router: Router
    let context: Context
    
    unowned let testCoordinator: TestCoordinator
    
    let navController = UINavigationController()
    
    init(router: Router, context: Context) {
        self.router = router
        self.context = context
        let coordinator = TestCoordinator(router: navController, context: context)
        self.testCoordinator = coordinator
        super.init()
        addChild(coordinator: testCoordinator)
    }
    
    override func start() {
        router.rootViewController = navController
        router.makeKeyAndVisible()
        testCoordinator.start()
    }
}
