import UIKit

@available(iOS 12.0, *)
class OTPTextField: UITextField {

    private let dotView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()

    private var dotCount: Int = 6 // You can customize the number of digits

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        // Customize text field properties
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        // Add dot view
        addSubview(dotView)
        dotView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dotView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            dotView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            dotView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            dotView.widthAnchor.constraint(equalToConstant: 10)
        ])

        // Customize dot view appearance
        dotView.layer.cornerRadius = 5
        dotView.isHidden = true
    }

    override func deleteBackward() {
        super.deleteBackward()
        updateDotView()
    }

    @objc private func textFieldDidChange() {
        updateDotView()
    }

    private func updateDotView() {
        let currentTextCount = text?.count ?? 0
        dotView.isHidden = currentTextCount == dotCount ? true : false
    }
}
