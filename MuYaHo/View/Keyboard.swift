
import UIKit

class KoreanTextView: UITextView {
    override var textInputMode: UITextInputMode? {
        return UITextInputMode.activeInputModes.first { $0.primaryLanguage == "ko-KR" }
    }
}
    