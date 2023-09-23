import UIKit
import SnapKit
import AVFoundation


//MARK: - Properties
class MainViewController: UIViewController {
    
    var videoBackground: LoopingVideoPlayerUIView!
    private let soundEffect = SoundEffect()
    private var shineLayer: CAGradientLayer!

        
    private lazy var bootleCount: UIImageView = {
        let imageView = UIImageView()
        let bottleCountImage = UIImage(named: "bottleCount")
        imageView.image = bottleCountImage
        return imageView
    }()
    
    private lazy var myPageButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(myPageButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "myPageButton"), for: .normal)
        return button
    }()
    
    private lazy var mainBottleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "mainBottle"), for: .normal)
        button.transform = CGAffineTransform(rotationAngle: .pi / 4)
        button.addTarget(self, action: #selector(mainBottleButtonTapped), for: .touchUpInside)
        
        // Shadow properties
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.6
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 10
        button.layer.masksToBounds = false  // Important: This should be false to allow shadows
        
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
        view.addSubview(bootleCount)
        view.addSubview(mainBottleButton)
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

        
        bootleCount.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(44)
            make.top.equalToSuperview().offset(80)
            make.left.equalToSuperview().offset(50)
        }
        
        mainBottleButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(100)

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
