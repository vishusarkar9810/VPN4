import UIKit

public class CustomButton: UIButton {

	private var _hasShadow: Bool!
	private var _hasBorder: Bool!

	// --------------------------------------
	// MARK: Life Cycle
	// --------------------------------------

    public init(_ frame: CGRect) {
		super.init(frame: frame)
		customize()
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		customize()
	}

	// --------------------------------------
	// MARK: Public
	// --------------------------------------

	public var hasShadow : Bool {
		get {
			return _hasShadow
		}
		set {
			dropShadow()
			_hasShadow = newValue
		}
	}

	public var hasBorder : Bool {
		get {
			return _hasBorder
		} set {
			setBorder(0.5)
			_hasBorder = newValue
		}
	}

	public func customize() {
		setRoundCorner(kCornerRadius)
	}

}
