import UIKit

enum CustomFont: String {
    
    case gamjaFlowerRegular = "GamjaFlower-Regular"
    
    func size(_ size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
