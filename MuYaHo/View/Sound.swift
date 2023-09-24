import Foundation
import AVFoundation

class SoundEffect {
    
    var oceanAudioPlayer: AVAudioPlayer?
    var windAudioPlayer: AVAudioPlayer?
    let defaultVolume: Float = 0.2
    let audioSession = AVAudioSession.sharedInstance()
 

    func playOceanSound() {
        guard let url = Bundle.main.url(forResource: "mainMusic", withExtension: "mp3") else { return }
        do {
            oceanAudioPlayer = try AVAudioPlayer(contentsOf: url)
            oceanAudioPlayer?.numberOfLoops = -1
            oceanAudioPlayer?.play()
            oceanAudioPlayer?.volume = defaultVolume
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)


        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
    
    func playWindSound() {
        guard let url = Bundle.main.url(forResource: "loginMusic", withExtension: "mp3") else { return }
        do {
            windAudioPlayer = try AVAudioPlayer(contentsOf: url)
            windAudioPlayer?.numberOfLoops = -1
            windAudioPlayer?.play()
            windAudioPlayer?.volume = defaultVolume

        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
}
