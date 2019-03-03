import UIKit
import HalfFive

class TestViewController: UIViewController {
    var viewModel: TestViewModel!
    
    let trashBag = TrashBag()
    
    @IBOutlet var nextQuestionLabel: UILabel!
    @IBOutlet var nextQuestionButton: UIButton!
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
        
        viewModel.nextQuestionLabel
            .run {[unowned self] value in
                self.nextQuestionLabel.text = value
            }
            .disposed(by: trashBag)
        
        viewModel.isSelectionValid
            .run {[unowned self] value in
                self.nextQuestionButton.isEnabled = value
                self.nextQuestionLabel.textColor = value
                    ? ColorName.testActionTextColorNormal.color
                    : ColorName.testActionTextColorDisabled.color
            }
            .disposed(by: trashBag)
    }
    
    @IBAction func nextQuestionButtonTap(_ sender: UIButton) {
        viewModel.nextQuestion
            .fire(event: ())
    }
}
