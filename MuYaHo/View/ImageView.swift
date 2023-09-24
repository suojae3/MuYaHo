//import UIKit
//
//class CustomImage: UIImageView {
//    
//    enum ImageStyle {
//        case loginTitleLabel
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    convenience init(style: ImageStyle) {
//        self.init(frame: <#CGRect#>)
//        
//        switch style {
//        case .loginTitleLabel:
//            setupLoginTitleLabel()
//        }
//    }
//    
//    private func setupLoginTitleLabel() {
//        self.text = "MainLabel"
//        self.textAlignment = .center
//        self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        self.layer.borderWidth = 3
//        self.layer.cornerRadius = 20
//
//    }
//}
