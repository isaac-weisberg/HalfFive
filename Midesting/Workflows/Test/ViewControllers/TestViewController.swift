import UIKit
import HalfFive

class TestViewController: UIViewController {
    var viewModel: TestViewModel!
    
    let trashBag = TrashBag()
    
    @IBOutlet var testCardView: TestCardView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.question
            .run(silo: testCardView.viewModelSilo)
            .disposed(by: trashBag)
    }
}
