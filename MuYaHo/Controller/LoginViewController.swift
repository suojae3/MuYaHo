import UIKit
import RiveRuntime
import SnapKit
import LocalAuthentication

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    private let soundEffect = SoundEffect()
    private let context = LAContext()
    private var error: NSError? = nil
    private let reason = "Please authenticate yourself to proceed."
    private let simpleVM = RiveViewModel(fileName: "login")
    
    private lazy var riveView: RiveView = RiveView()
    private lazy var loginTitle: CustomLabel = CustomLabel(style: .loginTitleLabel)
    private lazy var loginButton: CustomButton = {
        let button = CustomButton(style: .login)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var background: UIImageView = UIImageView()
    
    deinit {
        print("LoginViewController has been deinitialized!")
    }
    
    // MARK: - View Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
        soundEffect.playWindSound()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRiveBackground()
        setupUI()
    }
}

// MARK: - UI Configuration
private extension LoginViewController {
    
    func configureRiveBackground() {
        let riveView = simpleVM.createRiveView()
        view.addSubview(riveView)
        let width: CGFloat = 1000
        let height: CGFloat = 1000
        let x: CGFloat = (view.bounds.width - width) / 2
        let y: CGFloat = (view.bounds.height - height) / 2
        riveView.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    func setupUI() {
        view.addSubview(loginButton)
        view.addSubview(loginTitle)
        setupConstraints()
    }
    
    func setupConstraints() {
        loginTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(150)
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
        
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
    }
}

// MARK: - Button Actions
private extension LoginViewController {
    
    @objc func loginButtonTapped() {
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            print("Device does not support Face ID / Touch ID.")
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { [weak self] success, authenticationError in
            DispatchQueue.main.async {
                guard success else {
                    self?.handleAuthenticationFailure(error: authenticationError)
                    return
                }
                self?.handleAuthenticationSuccess()
            }
        }
    }
    
    func handleAuthenticationSuccess() {
        var userUUID = APIManager.getUUIDFromKeychain()
        if userUUID == nil {
            userUUID = UUID().uuidString
            APIManager.storeUUIDInKeychain(uuid: userUUID!)
        }
        
        print("UUID::::: \(userUUID!)")
        
        APIManager.shared.requestTokenWithUUID(uuid: userUUID!) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    APIManager.storeTokenInKeychain(token: token)
                    print("::::::token - \(token)")
                    self?.presentGreetVC()
                case .failure(let error):
                    print("Error fetching token:", error.localizedDescription)
                }
            }
        }
    }
    
    func handleAuthenticationFailure(error: Error?) {
        let errorMessage = error?.localizedDescription ?? "Unknown error"
        print("Authentication failed. Reason: \(errorMessage)")
    }
}

// MARK: - Transitions
private extension LoginViewController {
    
    func presentGreetVC() {
        UIView.animate(withDuration: 2.0, animations: {
            self.view.alpha = 0.0
        }) { [weak self] _ in
            let onBoardingVC = OnBoardingViewController()
            onBoardingVC.modalTransitionStyle = .crossDissolve
            onBoardingVC.modalPresentationStyle = .overFullScreen
            onBoardingVC.view.alpha = 0.0
            self?.soundEffect.windAudioPlayer?.stop()
            self?.present(onBoardingVC, animated: false, completion: {
                UIView.animate(withDuration: 2.0) {
                    onBoardingVC.view.alpha = 1.0
                }
            })
        }
    }
}
