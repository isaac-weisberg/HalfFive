import UIKit
import HalfFive

class TestCardView: XibModularView {
    @IBOutlet var answers: UIStackView!
    @IBOutlet var questionTitle: UILabel!
    @IBOutlet var progress: UILabel!
    
    lazy var viewModelSilo = Silo<TestCardViewModel, SchedulingMain> {[unowned self] viewModel in
        self.questionTitle.text = viewModel.questionTitle
        self.progress.text = viewModel.progressLabel
    }
}
