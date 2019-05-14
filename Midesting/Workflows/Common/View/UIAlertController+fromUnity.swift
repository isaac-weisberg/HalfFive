import HalfFive
import UIKit

extension UIAlertController {
    static func from(unity emission: EmissionSingular) -> (UIViewController) -> Conveyor<Void, SchedulingMain, HotnessCold>  {
        return { sourceViewController in
            return Conveyors
                .async { handle in
                    let controller = UIAlertController(title: nil, message: emission.description, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Okay", style: .cancel) { _ in
                        handle(())
                    }
                    controller.addAction(action)
                    sourceViewController.present(controller, animated: true)
                    return TrashVoid()
                }
                .assumeFiresOnMain()
        }
    }
}
