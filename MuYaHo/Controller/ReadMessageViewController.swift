import UIKit
import SnapKit

class ReadMessageViewController: UIViewController {

    // MARK: - Properties
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "x.circle"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        return button
    }()
    
    private lazy var letterView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "home"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 50)
        textView.autocorrectionType = .no
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.isEditable = false
        textView.delegate = self
        return textView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadRandomMessage()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.backgroundColor = .white
        
        [letterView, messageTextView, dismissButton].forEach { view.addSubview($0) }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        letterView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        messageTextView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        dismissButton.snp.makeConstraints {
            $0.top.equalTo(messageTextView.snp.bottom).offset(20)
            $0.right.equalTo(messageTextView.snp.right).inset(20)
            $0.size.equalTo(30)
        }
    }
    
    // MARK: - Actions
    @objc private func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func loadRandomMessage() {
        guard let accessToken = APIManager.getTokenFromKeychain() else {
            print("Token not found in keychain.")
            return
        }
        
        APIManager.shared.fetchRandomLetter(accessToken: accessToken) { [weak self] result in
            switch result {
            case .success(let letterData):
                DispatchQueue.main.async {
                    self?.messageTextView.text = letterData.content
                }
            case .failure(let error):
                print("loadMessageError")
                self?.handleAPIError(error: error)
            }
        }
    }
    
    // MARK: - Error Handling
    private func handleAPIError(error: APIError) {
        let errorMessage: String
        switch error {
        case .pointNotEnough:
            errorMessage = "Point not enough"
        case .letterNotLeft:
            errorMessage = "Letter not left, you read all letter"
        default:
            errorMessage = error.localizedDescription
        }
        showAlert(message: errorMessage)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITextViewDelegate
extension ReadMessageViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= 500
    }
}
