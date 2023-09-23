import UIKit
import SnapKit

class CustomAlert: UIView {

    enum AlertStyle {
        case warning
        case success
        case info
        case error
    }

    var titleLabel: UILabel!
    var messageLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    convenience init(style: AlertStyle, title: String, message: String) {
        self.init(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        setupUI(style: style, title: title, message: message)
        applyCommonFeatures()
    }

    private func applyCommonFeatures() {
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 6
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.cornerRadius = 20
    }

    private func setupUI(style: AlertStyle, title: String, message: String) {
        titleLabel = UILabel()
        messageLabel = UILabel()

        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0

        addSubview(titleLabel)
        addSubview(messageLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(30)
        }

        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }

        switch style {
        case .warning:
            self.backgroundColor = UIColor.yellow
            titleLabel.textColor = UIColor.black
            messageLabel.textColor = UIColor.black
        case .success:
            self.backgroundColor = UIColor.green
            titleLabel.textColor = UIColor.white
            messageLabel.textColor = UIColor.white
        case .info:
            self.backgroundColor = UIColor.blue
            titleLabel.textColor = UIColor.white
            messageLabel.textColor = UIColor.white
        case .error:
            self.backgroundColor = UIColor.red
            titleLabel.textColor = UIColor.white
            messageLabel.textColor = UIColor.white
        }
    }
}
