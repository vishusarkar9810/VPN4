import UIKit

class ChildViewController: NavigationBarViewController {

	// --------------------------------------
	// MARK: Overrides
	// --------------------------------------

//	override var leftBarButton: CustomGradientBorderButton? {
//		Graphics.createBarButton(image: "icon_back")
//	}

	override func handleLeftBarButtonEvent() {
		if isModal {
            dismiss(animated: true, completion: nil)
		} else {
            navigationController?.popViewController(animated: true)
		}
	}
}
