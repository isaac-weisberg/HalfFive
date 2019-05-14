import UIKit
import HalfFive

class TestViewController: UIViewController {
    var viewModel: TestViewModel!
    
    let trashBag = TrashBag()
    
    @IBOutlet var nextQuestionLabel: UILabel!
    @IBOutlet var nextQuestionButton: UIButton!
    @IBOutlet var testCardView: TestCardView!
    @IBOutlet var loadingView: LoadingView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
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
        
        viewModel.isLoading
            .run {[loadingView = loadingView!] isLoading in
                loadingView.isShown = isLoading
            }
            .disposed(by: trashBag)
        
        viewModel.unitySingular
            .map { UIAlertController.from(unity: $0.unitySingular) }
            .flatMapLatest {[unowned self] presentOn in
                presentOn(self)
            }
            .run { _ in }
            .disposed(by: trashBag)
        
        viewModel.nextQuestion.fire(event: ())
    }
    
    @IBAction func nextQuestionButtonTap(_ sender: UIButton) {
        viewModel.nextQuestion
            .fire(event: ())
    }
}
