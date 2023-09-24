import UIKit
import SnapKit


//MARK: - Properties
class WriteMessageViewController: UIViewController {
    
    let tabBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward.circle"), style: .plain, target: self, action: #selector(handleBackButton))
    


    // Define the UIImageView
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "home")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // Update the messageTextView definition
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = .clear  // Make background transparent
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.autocorrectionType = .no
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1.0
        return textView
    }()
    
    
    private lazy var textCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    
    private lazy var letterView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "home")
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.3
        return imageView
    }()
    
    private lazy var sendButton:CustomButton = {
        let button = CustomButton(style: .sendMessageButton)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }()
    
    private lazy var changeLetterButton:CustomButton = {
        let button = CustomButton(style: .changeLetterButton)
        button.addTarget(self, action: #selector(changeLetter), for: .touchUpInside)
        return button
    }()
    
    
}

//MARK: - View Cycle
extension WriteMessageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = tabBarButton
        setupUI()
        messageTextView.delegate = self
    }
}

extension WriteMessageViewController {
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func changeLetter() {
        
    }
    
    @objc func handleBackButton() {
        if !messageTextView.text.isEmpty {

            let alertController = UIAlertController(title: "보내지 못한 편지", message: "\n아직 보내지 못한 편지가 남아있어요\n메세지는 저장되지 않아요 :)", preferredStyle: .alert)
            
            let goBackAction = UIAlertAction(title: "Go Back", style: .destructive) { [weak self] _ in
                self?.dismiss(animated: true)
            }
            
            let stayAction = UIAlertAction(title: "Stay", style: .cancel, handler: nil)
            
            alertController.addAction(goBackAction)
            alertController.addAction(stayAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            dismiss(animated: true)
        }
    }
    
    @objc func sendMessage() {
        APIManager.shared.sendMessage(content: "Your message content here", accessToken: "Your access token here") { result in
            switch result {
            case .success(let isSuccess):
                if isSuccess {
                    print("Message sent successfully!")
                } else {
                    print("Failed to send message.")
                }
            case .failure(let error):
                print("Error sending message: \(error)")
            }
        }
    }
}







//MARK: - Setup UI

private extension WriteMessageViewController {
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(letterView)
        view.addSubview(sendButton)
        view.addSubview(backgroundImageView)
        view.addSubview(messageTextView)
        view.addSubview(textCountLabel)
        messageTextView.delegate = self
        setupConstraints()
        
    }
    
}

//MARK: - Constraints
private extension WriteMessageViewController {
    func setupConstraints() {
        letterView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(letterView.snp.bottom).offset(100)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(50)
        }
        
        messageTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(180)
            make.bottom.equalToSuperview().offset(-220)
            make.centerX.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(430)
        }
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalTo(messageTextView.snp.top)
            make.bottom.equalTo(messageTextView.snp.bottom)
            make.left.equalTo(messageTextView.snp.left)
            make.right.equalTo(messageTextView.snp.right)
        }
        
        textCountLabel.snp.makeConstraints { make in
            make.bottom.equalTo(messageTextView.snp.bottom).offset(-20)
            make.right.equalTo(messageTextView.snp.right).offset(-20)
        }
        
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(messageTextView.snp.bottom).offset(80)
            make.centerX.equalToSuperview()
        }
    }
}

//MARK: - UITextViewDelegate
extension WriteMessageViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        let projectedLength = updatedText.count
        textCountLabel.text = "\(projectedLength)/200"
        return projectedLength >= 0 && projectedLength <= 200
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        let currentLength = textView.text.count
        textCountLabel.text = "\(currentLength)/200"
    }
    
}


//MARK: - Popup sheet

extension WriteMessageViewController {
    func popUpsheet() {
        
    }
}
