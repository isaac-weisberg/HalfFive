import UIKit
import HalfFive

class AnswerTextualView: XibModularView {
    @IBOutlet var label: UILabel!
    @IBOutlet var deselectedView: UIView!
    @IBOutlet var selectedView: UIView!
    
    var trashBag = TrashBag()
    var viewModel: AnswerTextualViewModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
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
        viewModel.action.asSilo().fire(event: ())
    }
}


private extension AnswerTextualView {
    func setup() {
        deselectedView.layer.borderWidth = 2
        deselectedView.layer.borderColor = ColorName.testAnswerDeselectedViewBorder.color.cgColor
    }
}
