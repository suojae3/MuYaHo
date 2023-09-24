


import UIKit
import SnapKit

//Properties & Deinit
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
    
}


//MARK: - Setup UI
extension SendCompletionViewController {
    func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(completionMail)
        view.addSubview(completionLabel)

        setupConstraints()
    }
    
    func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        completionMail.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(5.0/7.0)
        }
        
        completionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(completionMail.snp.bottom).offset(30)
        }
    }
}










