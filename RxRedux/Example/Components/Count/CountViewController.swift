import UIKit
import SnapKit
import Action

enum CountViewAccessibility: String {
    case countValue
    case countDecrement
    case countIncrement
}

class CountViewController: UIViewController {
    lazy var value = UILabel.value
    lazy var decrement = UIButton.decrement
    lazy var increment = UIButton.increment
    
    var presenter: CountPresenter<CountViewController>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        presenter?.attachView(self)
    }
    
    deinit {
        presenter?.detachView()
    }
    
    private func render() {
        view.backgroundColor = .white
        
        let padding = CGFloat(20)
        let buttonHeight = CGFloat(60)
        
        view.addSubview(value) { make in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide).inset(padding)
        }
        
        view.addSubview(decrement) { make in
            make.height.equalTo(buttonHeight)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(padding)
        }
        
        view.addSubview(increment) { (make) in
            make.height.equalTo(buttonHeight)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(padding)
            make.bottom.equalTo(decrement.snp.top).offset(-padding)
        }
    }
}

extension CountViewController: CountView {
    func setCountText(_ text: String) {
        value.text = text
    }
    
    func setDecrementAction(_ action: CocoaAction) {
        decrement.rx.action = action
    }
    
    func setDecrementText(_ text: String) {
        decrement.setTitle(text, for: .normal)
    }
    
    func setIncrementAction(_ action: CocoaAction) {
        increment.rx.action = action
    }
    
    func setIncrementText(_ text: String) {
        increment.setTitle(text, for: .normal)
    }
}

fileprivate extension UILabel {
    static var value: UILabel {
        let label = UILabel(CountViewAccessibility.countValue)
        return label
    }
}

fileprivate extension UIButton {
    static var decrement: UIButton {
        let button = UIButton(CountViewAccessibility.countDecrement)
        return button
    }
    
    static var increment: UIButton {
        let button = UIButton(CountViewAccessibility.countIncrement)
        return button
    }
}

