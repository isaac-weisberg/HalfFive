import UIKit
import HalfFive

class AnswerTextualView: XibModularView {
    @IBOutlet var label: UILabel!
    @IBOutlet var deselectedView: UIView!
    @IBOutlet var selectedView: UIView!
    
    var trashBag = TrashBag()
    var viewModel: AnswerTextualViewModel!
    
    func apply(viewModel: AnswerTextualViewModel) {
        trashBag = TrashBag()
        self.viewModel = viewModel
        
        label.text = viewModel.text
        
        viewModel.isSelected
            .run {[unowned self] selected in
                self.deselectedView.isHidden = selected
                self.selectedView.isShown = selected
            }
            .disposed(by: trashBag)
    }
    
    @IBAction func tap(_ sender: Any) {
        viewModel.action.fire(event: ())
    }
}
