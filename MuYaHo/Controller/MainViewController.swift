import UIKit
import SnapKit
import AVFoundation


//MARK: - Properties
class MainViewController: UIViewController {
    
    var videoBackground: LoopingVideoPlayerUIView!
    private let soundEffect = SoundEffect()
    
    private lazy var bottleCount: UIImageView = {
        let imageView = UIImageView()
        let bottleCountImage = UIImage(named: "bottleCount")
        imageView.image = bottleCountImage
        return imageView
    }()
    
    private lazy var bottleCountLabel: CustomLabel = {
        let label = CustomLabel(style: .bottleCountLabel)
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
    
    private lazy var writeMessageButton = {
        let button = CustomButton(style: .writeMessage)
        button.addTarget(self, action: #selector(writeMessageButtonTapped), for: .touchUpInside)
        return button
    }()
}

//MARK: - View Cycle
extension MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoBackground = LoopingVideoPlayerUIView(frame: self.view.bounds)
        self.view.addSubview(videoBackground)
        self.view.sendSubviewToBack(videoBackground) // Send to back to make sure it's behind other views
        soundEffect.playOceanSound()
        setupUI()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupFloatingAnimation()
    }
    
    
}

//MARK: - Setup UI
extension MainViewController {
    
    
    
    func setupUI() {
        
        view.addSubview(myPageButton)
        view.addSubview(bottleCount)
        view.addSubview(mainBottleButton)
        view.addSubview(writeMessageButton)
        bottleCount.addSubview(bottleCountLabel)
        setupConstraints()
    }
}

//MARK: - Constraints
extension MainViewController {
    func setupConstraints() {
        
        myPageButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(80)
            make.center.equalToSuperview()
        }
        
        videoBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        bottleCount.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(44)
            make.top.equalToSuperview().offset(80)
            make.left.equalToSuperview().offset(30)
        }
        
        bottleCountLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainBottleButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        writeMessageButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-50)
            make.right.equalToSuperview().offset(-50)
        }
        
    }
}

//MARK: - Button Action
extension MainViewController {
    
    @objc private func mainBottleButtonTapped() {
        DispatchQueue.main.async {
            self.videoBackground.toggleOpacity()
        }
    }
    
    @objc private func myPageButtonTapped() {
    }
    
    @objc private func writeMessageButtonTapped() {
        let writeMessageVC = WriteMessageViewController()
        let navController = UINavigationController(rootViewController: writeMessageVC)

        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}



//MARK: - Button Animation
extension MainViewController {
    
    func setupFloatingAnimation() {
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.duration = 1.5
        animation.fromValue = mainBottleButton.layer.position.y
        animation.toValue = mainBottleButton.layer.position.y - 10
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        mainBottleButton.layer.add(animation, forKey: "floatingAnimation")
    }
    
}
