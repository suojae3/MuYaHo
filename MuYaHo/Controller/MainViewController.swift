import UIKit
import SnapKit
import AVFoundation

class MainViewController: UIViewController {
    
    // MARK: - Properties
    private var videoBackground: LoopingVideoPlayerUIView!
    private let soundEffect = SoundEffect()
    private let fadeTransitioningDelegate = FadeTransitioningDelegate()
    
    private lazy var bottleCount: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "bottleCount"))
        return imageView
    }()
    
    private lazy var bottleCountLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var myPageButton: CustomButton = {
        let button = CustomButton(style: .myPageButton)
        button.addTarget(self, action: #selector(myPageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var mainBottleButton: CustomButton = {
        let button = CustomButton(style: .mainBottleButton)
        button.addTarget(self, action: #selector(mainBottleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var writeMessageButton: CustomButton = {
        let button = CustomButton(style: .writeMessage)
        button.addTarget(self, action: #selector(writeMessageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        updateUserPoints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupFloatingAnimation()
    }
    
    // MARK: - Setup
    private func setupViews() {
        setupVideoBackground()
        soundEffect.playOceanSound()
        setupUIComponents()
        setupConstraints()
    }
    
    private func setupVideoBackground() {
        videoBackground = LoopingVideoPlayerUIView(frame: self.view.bounds)
        self.view.addSubview(videoBackground)
        self.view.sendSubviewToBack(videoBackground)
    }
    
    private func setupUIComponents() {
        [myPageButton, bottleCount, mainBottleButton, writeMessageButton].forEach { view.addSubview($0) }
        bottleCount.addSubview(bottleCountLabel)
    }
    
    private func updateUserPoints() {
        guard let accessToken = APIManager.getTokenFromKeychain() else {
            print("Token not found in keychain.")
            return
        }
        
        APIManager.shared.fetchUserDetails(accessToken: accessToken) { [weak self] result in
            switch result {
            case .success(let userData):
                DispatchQueue.main.async {
                    self?.bottleCountLabel.text = "\(userData.point)"
                }
            case .failure(let error):
                print("Failed to fetch user points:", error.localizedDescription)
            }
        }
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        myPageButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(80)
            $0.right.equalToSuperview().offset(-30)
        }
        
        videoBackground.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottleCount.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(44)
            $0.top.equalToSuperview().offset(80)
            $0.left.equalToSuperview().offset(30)
        }
        
        bottleCountLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        mainBottleButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        writeMessageButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-50)
            $0.right.equalToSuperview().offset(-50)
        }
    }
    
    // MARK: - Animations
    private func setupFloatingAnimation() {
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.duration = 1.5
        animation.fromValue = mainBottleButton.layer.position.y
        animation.toValue = mainBottleButton.layer.position.y - 10
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        mainBottleButton.layer.add(animation, forKey: "floatingAnimation")
    }
    
    // MARK: - Button Actions
    @objc private func mainBottleButtonTapped() {
        let popupVC = PopupViewController()
        popupVC.transitioningDelegate = fadeTransitioningDelegate
        popupVC.modalPresentationStyle = .custom
        present(popupVC, animated: true)
    }
    
    @objc private func myPageButtonTapped() {
        let myPageVC = MyPageViewController()
        let navController = UINavigationController(rootViewController: myPageVC)
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    @objc private func writeMessageButtonTapped() {
        let writeMessageVC = WriteMessageViewController()
        let navController = UINavigationController(rootViewController: writeMessageVC)
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}
