import UIKit

class CustomLabel: UILabel {
    
    enum LabelStyle {
        case loginTitleLabel
        case myPageLabel
        case myPageCount
        case myPageCountRightLabel
        case myPageMenuLabel
        case mainPageLabel
        case bottleCountLabel
        
        //CompletionView
        case completionLabel
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(style: LabelStyle) {
        self.init()
        
        switch style {
        case .loginTitleLabel:
            setupLoginTitleLabel()
        case .myPageLabel:
            setupMyPageLabel()
        case .myPageCount:
            setupMyPageCountLabel()
        case .myPageCountRightLabel:
            setupMyPageCountRightLabel()
        case .myPageMenuLabel:
            setupMyPageMenuLabel()
        case .mainPageLabel:
            setupMainPageLabel()
        case .bottleCountLabel:
            setupBottleCountLabel()
        case .completionLabel:
            setupCompletionLabel()
        }
    }
    
    private func setupLoginTitleLabel() {
        self.text = "무야호~"
        self.font = CustomFont.gamjaFlowerRegular.size(50)
        self.textAlignment = .center
    }
    
    private func setupMyPageLabel() {
        self.backgroundColor = .black
        self.layer.cornerRadius = 20
    }
    
    private func setupMyPageCountLabel() {
    }
    
    private func setupMyPageCountRightLabel() {
    }
    
    
    private func setupMyPageMenuLabel() {
    }
    
    
    private func setupBottleCountLabel() {
        self.text = " 3 / 5" // example text
        self.font = CustomFont.gamjaFlowerRegular.size(30)
        self.textColor = .white
        self.textAlignment = .center

    }
    
    private func setupMainPageLabel() {
        self.text = "무야호!"
        self.textColor = .black
        self.font = UIFont.boldSystemFont(ofSize: 20)
        self.font = CustomFont.gamjaFlowerRegular.size(20)
    }
    
    private func setupCompletionLabel() {
        self.text = "편지가 전송되었어요\n소중한 이야기 감사해요!"
        self.font = CustomFont.gamjaFlowerRegular.size(20)
        self.textColor = .black
    }
}
