import PastFive
import UIKit

class ViewController: UIViewController {
    var disposeBag = DisposeBag()

    let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    let button = UIButton(type: .system)

    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        [label, button].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        [label, button].forEach(view.addSubview)

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12)
        ])
        button.setTitle("Reroll", for: .normal)
    }

    var input: Observable<MainViewModelInput, MainScheduler> {
        return button.rx.tap
            .map { void in
                .buttonTap
            }
    }

    func apply(viewModel: MainViewModelProtocol) {
        disposeBag = DisposeBag()

        viewModel.titleText
            .subscribe(to: label.rx.text)
            .disposed(by: disposeBag)
    }
}
