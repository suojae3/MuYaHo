import UIKit


class OnBoardingViewController: UIViewController   {
    
    let soundEffect = SoundEffect()
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = UIImage(named: "greet")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    private lazy var enrolledButton: CustomButton = {
        let button = CustomButton(style: .login)
        button.addTarget(self, action: #selector(presentMainVC), for: .touchUpInside)
        return button
    }()
    
    deinit {
        print("GreetViewController has been deinitialized!")
    }
}


//MARK: - View Cycle

extension OnBoardingViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationController?.popViewController(animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called22")
        soundEffect.windAudioPlayer?.stop()
    }
}


//MARK: - Setup UI

extension OnBoardingViewController {
    
    func setupUI() {
        view.addSubview(backgroundImage)
        view.addSubview(textField)
        view.addSubview(enrolledButton)
        constraints()
        
    }
    
    func constraints() {
        
        backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        enrolledButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-130)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(180)
            $0.height.equalTo(50)
        }
    }
    
}


//MARK: - Transition Effect
extension OnBoardingViewController {
    @objc func presentMainVC() {
        let fadeTransitioningDelegate = FadeTransitioningDelegate()
        let mainVC = MainViewController()
        let navVC = UINavigationController(rootViewController: mainVC)
        navVC.modalPresentationStyle = .fullScreen
        navVC.transitioningDelegate = fadeTransitioningDelegate
        self.present(navVC, animated: true) {
        }
    }
}
