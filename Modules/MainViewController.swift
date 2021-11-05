import UIKit
import AVFoundation

class MainViewController: UIViewController {

    var player: AVPlayer?
    var currentIndex = 0
    var timeObserverToken: Any?
    
    var cards = [
        VoiceCardModel(backgroundColor: .fromHex(hex: 0xdc6150), soundUrl: Bundle.main.url(forResource: "Bad", withExtension: ".mp3"), timeInterval: .zero),
        VoiceCardModel(backgroundColor: .fromHex(hex: 0x8034c2), soundUrl: Bundle.main.url(forResource: "summer", withExtension: ".mp3"), timeInterval: .zero),
        VoiceCardModel(backgroundColor: .fromHex(hex: 0x03bb9a), soundUrl: Bundle.main.url(forResource: "Million", withExtension: ".mp3"), timeInterval: .zero),
        VoiceCardModel(backgroundColor: .fromHex(hex: 0x06c646), soundUrl: Bundle.main.url(forResource: "Дора", withExtension: ".mp3"), timeInterval: .zero),
        VoiceCardModel(backgroundColor: .fromHex(hex: 0xff9a02), soundUrl: Bundle.main.url(forResource: "Благо", withExtension: ".mp3"), timeInterval: .zero),
        VoiceCardModel(backgroundColor: .fromHex(hex: 0x7c7c7c), soundUrl: Bundle.main.url(forResource: "Big Tymers", withExtension: ".mp3"), timeInterval: .zero)
    ]
    
    var mainView: MainView {
        return view as! MainView
    }
    
    override func loadView() {
        let view = MainView()
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.cardsCollection.delegate = self
        mainView.cardsCollection.dataSource = self
    }
    
    private func playSound(from url: URL?, atTime: CMTime) {
        guard let url = url else { return }
        
        player = AVPlayer(url: url)
        addPeriodicTimeObserver()
        
        if let player = player {
            player.seek(to: atTime)
            player.play()
        }
    }
    
    private func getSeconds(from url: URL?) -> Double {
        guard let url = url else { return .zero }

        let player = AVPlayer(url: url)
        
        if let time = player.currentItem?.asset.duration.seconds {
            return time
        }
        
        return .zero
    }
    
    private func getDurationString(for url: URL?) -> String {
        guard let url = url else { return "00:00"}
        
        let time = getSeconds(from: url)
        let seconds = Int(time) % 60
        let minutes = Int(time / 60)
        
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
    
    func addPeriodicTimeObserver() {
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 1/60, preferredTimescale: timeScale)
        
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
            guard let self = self else { return }
            
            if let item = self.player?.currentItem {
                let cell = self.mainView.cardsCollection.cellForItem(at: IndexPath(item: self.currentIndex, section: 0)) as! VoiceCardCell
                cell.soundLineView.frame.size.width = (time.seconds * Double(cell.soundLineBackView.frame.width)) / item.asset.duration.seconds
            }
        }
    }
    
    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            } else {
                if player.currentItem!.asset.duration.seconds - player.currentTime().seconds < 1 {
                    player.seek(to: .zero)
                }
                
                player.play()
            }
        } else {
            playSound(from: cards[indexPath.row].soundUrl, atTime: cards[indexPath.row].timeInterval)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VoiceCardCell.description(), for: indexPath) as! VoiceCardCell
        let card = cards[indexPath.row]
        let width = (cards[currentIndex].timeInterval.seconds * Double(cell.soundLineBackView.frame.width)) / getSeconds(from: card.soundUrl)
        
        cell.titleLabel.text = card.soundUrl?.deletingPathExtension().lastPathComponent
        cell.gradientLayer.colors = [card.backgroundColor.cgColor, card.backgroundColor.withAlphaComponent(0.7).cgColor]
        cell.durationLabel.text = getDurationString(for: card.soundUrl)
        cell.soundLineView.frame.size.width = width
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let voiceCell = cell as! VoiceCardCell
        let card = cards[indexPath.row]
        let width = (card.timeInterval.seconds * Double(voiceCell.soundLineBackView.frame.width)) / getSeconds(from: card.soundUrl)
        
        voiceCell.soundLineView.frame.size.width = width
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let player = player {
            cards[currentIndex].timeInterval = player.currentTime()
        }
        
        removePeriodicTimeObserver()
        player = nil
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cellWidth = (UIScreen.main.bounds.width - 36 - 36) * 0.7
        let spacing = 50.0
        currentIndex = Int(scrollView.contentOffset.x) / Int(cellWidth + spacing)
        let cell = mainView.cardsCollection.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as! VoiceCardCell
        
        playSound(from: cards[currentIndex].soundUrl, atTime: cards[currentIndex].timeInterval)
        
        if let item = player?.currentItem {
            cell.soundLineView.frame.size.width = (cards[currentIndex].timeInterval.seconds * Double(cell.soundLineBackView.frame.width)) / item.asset.duration.seconds
        }
    }
}

