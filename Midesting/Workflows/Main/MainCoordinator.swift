import UIKit

class MainCoordinator: Coordinator {
    typealias Router = UIWindow
    typealias Context = AppContext
    
    let router: Router
    let context: Context
    
    let testCoordinator: TestCoordinator
    
    let navController = UINavigationController()
    
    init(router: Router, context: Context) {
        self.router = router
        self.context = context
        self.testCoordinator = TestCoordinator(router: navController, context: context)
        super.init()
    }
    
    override func start() {
        testCoordinator.start()
        router.makeKeyAndVisible()
    }
}
