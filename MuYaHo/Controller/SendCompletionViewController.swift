


import UIKit
import SnapKit

//MARK: - Properties & Deinit
class SendCompletionViewController: UIViewController {
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "home2")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var mailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "home2")
        return imageView
    }()
    
    private lazy var completionMail: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "completionLetter")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var completionLabel:CustomLabel = {
        let label = CustomLabel(style: .completionLabel)
        return label
    }()
    
    private lazy var backToMainButton: CustomButton = {
        let button = CustomButton(style: .login)
        button.addTarget(self, action: #selector(backToMainButtonTapepd), for: .touchUpInside)
        return button
    }()

    deinit {
        print("SendCompletionViewController deinit!!!")
    }
}


//MARK: - View Cycle
extension SendCompletionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}


//MARK: - Button Action
extension SendCompletionViewController {
    @objc func backToMainButtonTapepd() {
        let mainVC = MainViewController()
        mainVC.modalTransitionStyle = .crossDissolve
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}


//MARK: - Setup UI
extension SendCompletionViewController {
    func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(completionMail)
        view.addSubview(completionLabel)
        view.addSubview(backToMainButton)
        setupConstraints()
    }
    
    func setupConstraints() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        completionMail.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(5.0/7.0)
        }
        
        completionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(completionMail.snp.bottom).offset(30)
        }
        
        backToMainButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(completionLabel.snp.bottom).offset(30)
        }
    }
}










