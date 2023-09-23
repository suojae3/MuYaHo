import AVFoundation
import UIKit

class LoopingVideoPlayerUIView: UIView {
    
    private var playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVideoPlayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupVideoPlayer()
    }
    
    private func setupVideoPlayer() {
        guard let videoFileUrl = Bundle.main.url(forResource: "mainVideo", withExtension: "mp4") else {
            print("Video not found")
            return
        }
        
        let playerItem = AVPlayerItem(url: videoFileUrl)
        
        // Set up player
        let queuePlayer = AVQueuePlayer(playerItem: playerItem)
        playerLayer.player = queuePlayer
        playerLayer.videoGravity = .resizeAspectFill
        self.layer.addSublayer(playerLayer)
        
        // Create a new player looper with the queue player and template item
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        
        // Begin looping playback
        queuePlayer.play()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    func toggleOpacity() {
        playerLayer.opacity = (playerLayer.opacity == 1.0) ? 0.3 : 1.0
    }
}
