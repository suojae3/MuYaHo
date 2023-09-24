import UIKit
import SnapKit



class MyPageViewController: UIViewController {
    
    private lazy var backGroundImage: UIImageView = {
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = UIImage(named: "myPageBackground")
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var dayCount: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    private lazy var letterCount: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var musicOffLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var notificationLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var musicOffButton: CustomButton = {
        let button = CustomButton(style: .musicOffButton)
        button.addTarget(self, action: #selector(toggleOffMusic), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var notificationButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
}

//MARK: - Button Action
extension MyPageViewController {
    @objc func toggleOffMusic() {
        let soundToggle = SoundEffect().oceanAudioPlayer?.stop()
        
        //나중에 음악 토글 검색해서 넣기
        //soundToggle.toggle()
    }
}



//MARK: - View Cycle
extension MyPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setupUI()
        
        
    }
}



//MARK: - Setup UI
extension MyPageViewController {
    
    
    func setupUI() {
        view.addSubview(backGroundImage)
        setConstraints()
    }
    
    func setConstraints() {
        backGroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
