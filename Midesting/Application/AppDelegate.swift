import UIKit

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var mainCoordinator: MainCoordinator?
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let context = AppContext()
        let coordinator = MainCoordinator(router: window, context: context)
        self.mainCoordinator = coordinator
        
        coordinator.start()
    }
}
