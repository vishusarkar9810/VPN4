import UIKit

protocol CustomHeaderViewDelegate: class {
    func didSelectTab(at index: Int)
}

class CustomTableHeaderView: UIView {
    weak var delegate: CustomHeaderViewDelegate?
    private var tabLabels: [UILabel] = []
    private var selectIndicator: UIView!
    public var selectedIndex: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBlurBackground()
        setupTabLabels()
        setupSelectIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBlurBackground() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bounds
        addSubview(blurView)
    }
    
    private func setupTabLabels() {
        let tabTitles = ["Offers", "Activity", "Event"]
        let labelWidth = frame.width / CGFloat(tabTitles.count)
        
        for (index, title) in tabTitles.enumerated() {
            let label = UILabel(frame: CGRect(x: CGFloat(index) * labelWidth, y: 0, width: labelWidth, height: frame.height))
            label.textAlignment = .center
            label.text = title
            label.tag = index
            label.isUserInteractionEnabled = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tabTapped(_:)))
            label.addGestureRecognizer(tapGesture)
            
            addSubview(label)
            tabLabels.append(label)
        }
    }
    
    private func setupSelectIndicator() {
        let indicatorHeight: CGFloat = 3.0
        let indicatorWidth: CGFloat = 30.0
        
        selectIndicator = UIView(frame: CGRect(x: 0, y: frame.height - 10, width: indicatorWidth, height: indicatorHeight))
        selectIndicator.center.x = tabLabels[selectedIndex].center.x
        addSubview(selectIndicator)
    }
    
    public func setupData(_ index: Int) {
        selectedIndex = index
        moveSelectIndicator(to: index)
    }

    
    @objc private func tabTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedLabel = sender.view as? UILabel else { return }
        let selectedIndex = selectedLabel.tag
        
        moveSelectIndicator(to: selectedIndex)
        delegate?.didSelectTab(at: selectedIndex)
    }
    
    private func moveSelectIndicator(to index: Int) {
        let label = tabLabels[index]
        
        UIView.animate(withDuration: 0.3) {
            self.selectIndicator.center.x = label.center.x
            self.selectIndicator.frame.size.width = 30
        }
        
        selectedIndex = index
    }

}
