import UIKit
import SnapKit



class MyPageViewController: UIViewController {
    
    private lazy var leftBarButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBackButton))

    
    private lazy var backGroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "myPageBackground")
        imageView.contentMode = .scaleToFill
        imageView.alpha = 0.8
        return imageView
    }()
    
    
    private lazy var shellImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "Shellfish")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    
    private lazy var nickNameLabel: CustomLabel = {
        let label = CustomLabel(style: .myPageLabel)
        return label
    }()
    
    private lazy var dayCount: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    
    private lazy var letterCount: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private lazy var musicOffLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Music Off"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private lazy var musicOffButton: UIButton = {
        let button = UIButton()
        button.setTitle("Toggle", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(toggleOffMusic), for: .touchUpInside)
        return button
    }()

    private lazy var notificationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Notifications"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private lazy var notificationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Toggle", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    deinit {
        print("MyPageViewController deinitalize!!")
    }
    
}

//MARK: - View Cycle
extension MyPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = leftBarButton
        setupUI()
    }
}

//MARK: - Button Action
extension MyPageViewController {
    @objc func toggleOffMusic() {
        
    }
    
    
    @objc func handleBackButton() {
        print("Back button tapped")
        dismiss(animated: true)
    }

    
}


//MARK: - Setup UI
extension MyPageViewController {
    
    func setupUI() {
        view.addSubview(backGroundImage)
        view.addSubview(shellImage)
        view.addSubview(nickNameLabel)
        view.addSubview(dayCount)
        view.addSubview(letterCount)
        view.addSubview(musicOffLabel)
        view.addSubview(musicOffButton)
        view.addSubview(notificationLabel)
        view.addSubview(notificationButton)
        setConstraints()
    }
     
    func setConstraints() {
        backGroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        shellImage.snp.makeConstraints {
            $0.height.equalTo(150)
            $0.width.equalTo(220)
            $0.top.equalToSuperview().offset(130)
            $0.centerX.equalToSuperview()
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(170)
            $0.top.equalTo(shellImage.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }

        dayCount.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(50)  // 50 is a placeholder, adjust as needed
        }
        
        letterCount.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(20)
            $0.right.equalToSuperview().offset(-50)  // -50 is a placeholder, adjust as needed
        }

        musicOffLabel.snp.makeConstraints {
            $0.top.equalTo(dayCount.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(50) // 50 is a placeholder, adjust as needed
        }

        musicOffButton.snp.makeConstraints {
            $0.centerY.equalTo(musicOffLabel)
            $0.left.equalTo(musicOffLabel.snp.right).offset(10)
        }

        notificationLabel.snp.makeConstraints {
            $0.top.equalTo(musicOffLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(50) // 50 is a placeholder, adjust as needed
        }

        notificationButton.snp.makeConstraints {
            $0.centerY.equalTo(notificationLabel)
            $0.left.equalTo(notificationLabel.snp.right).offset(10)
        }
    }

    
    
}
