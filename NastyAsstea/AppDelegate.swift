import UIKit

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let viewController = ViewController()

        let viewModel = MainViewModel(inputs: viewController.input)
        viewController.apply(viewModel: viewModel)

        window?.rootViewController = viewController

        window?.makeKeyAndVisible()

        return true
    }
}
