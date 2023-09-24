import UIKit

class CustomButton: UIButton {
    
    enum ButtonStyle {
        
        //Login
        case login
        
        //OnBoarding
        case onBoarding
        
        //Main
        case mainBottleButton
        case writeMessage
        case myPageButton
        case sendMessageButton
        
        //My Page
        case musicOffButton
        case notificationButton
        
        //Reading Letter
        case changeLetterButton
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(style: ButtonStyle) {
        self.init()
        
        switch style {
        case .login:
            setupLoginButton()
        case.onBoarding:
            setupOnBoardingButton()
        case .writeMessage:
            setupWriteMessageButton()
        case .myPageButton:
            setupMypageButton()
        case .sendMessageButton:
            setupSendMessageButton()
        case .mainBottleButton:
            setupmainBottleButton()
        case .musicOffButton:
            setupMusicButton()
        case .notificationButton:
            setupNotificationButton()
        case .changeLetterButton:
            setupchangeLetterButton()
        }
        
        applyCommonFeature()
        
    }
    
    private func applyCommonFeature() {
    }
    
    private func setupLoginButton() {
        self.backgroundColor = .white.withAlphaComponent(0.75)
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 10
        self.layer.masksToBounds = false
        self.frame = CGRect(x: 0, y: 0, width: 160, height: 50)
        self.setTitle("Login", for: .normal)
        self.titleLabel?.font = CustomFont.gamjaFlowerRegular.size(30)
        self.setTitleColor(.black, for: .normal)
    }
    
    private func setupOnBoardingButton() {
        self.layer.backgroundColor = UIColor(red: 0.09, green: 0.714, blue: 0.737, alpha: 1).cgColor
        self.frame = CGRect(x: 0, y: 0, width: 160, height: 50)
        
    }
    
    private func setupWriteMessageButton() {
        self.layer.cornerRadius = 50
        self.layer.backgroundColor = UIColor(red: 0.09, green: 0.714, blue: 0.737, alpha: 1).cgColor
        self.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        self.setImage(UIImage(named: "writeIcon"), for: .normal)
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 10
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor

    }
    
    private func setupMypageButton() {
        self.setImage(UIImage(named: "myPageButton"), for: .normal)
        self.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
    }
    
    
    private func setupSendMessageButton() {
        self.frame = CGRect(x: 0, y: 0, width: 100, height: 80)
        self.layer.cornerRadius = 20
        self.layer.backgroundColor = UIColor(red: 0.09, green: 0.714, blue: 0.737, alpha: 1).cgColor
        self.setTitle("  편지전송", for: .normal)
        self.setImage(UIImage(systemName: "envelope"), for: .normal)
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 10
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor

    }
    
    
    private func setupmainBottleButton() {
        self.setImage(UIImage(named: "mainBottle"), for: .normal)
        self.transform = CGAffineTransform(rotationAngle: .pi / 4)
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 10
        self.layer.masksToBounds = false  // Important: This should be false to allow shadows        
        self.layer.shadowColor = UIColor.black.cgColor

    }
    
    private func setupMusicButton() {
        
        
        
    }
    
    
    private func setupNotificationButton() {
    
    }
    
    
    private func setupchangeLetterButton() {
        
    }
}
