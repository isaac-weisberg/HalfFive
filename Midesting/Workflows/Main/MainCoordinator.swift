import UIKit

class MainCoordinator: Coordinator {
    typealias Router = UIWindow
    typealias Context = AppContext
    
    let router: Router
    let context: Context
    
    init(router: Router, context: Context) {
        self.router = router
        self.context = context
        super.init()
    }
    
    let navController = UINavigationController()
    
    override func start() {
        router.rootViewController = navController
        router.makeKeyAndVisible()
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.blue
        navController.pushViewController(vc, animated: true)
    }
}
