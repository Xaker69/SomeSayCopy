import UIKit
import AVFoundation

class MainViewController: UIViewController {

    var player: AVAudioPlayer?
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
    
    private func playSound(from url: URL?, atTime: TimeInterval) {
        guard let url = url else { return }

        do {
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            if let player = player {
                player.currentTime = atTime
                player.play()
            }
        } catch {
            print(error)
        }
    }
    
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let player = player {
            if player.isPlaying {
                player.pause()
            } else {
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
        let color = cards[indexPath.row].backgroundColor
        let title = cards[indexPath.row].soundUrl?.deletingPathExtension().lastPathComponent
        
        cell.titleLabel.text = title
        cell.gradientLayer.colors = [color.cgColor, color.withAlphaComponent(0.7).cgColor]
        
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let player = player {
            let cellWidth = UIScreen.main.bounds.width - 36 - 36
            let spacing = 24.0
            let index = Int(scrollView.contentOffset.x) / Int(cellWidth + spacing)
            cards[index].timeInterval = player.currentTime
        }
        player = nil
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cellWidth = UIScreen.main.bounds.width - 36 - 36
        let spacing = 24.0
        let index = Int(scrollView.contentOffset.x) / Int(cellWidth + spacing)
        
        playSound(from: cards[index].soundUrl, atTime: cards[index].timeInterval)
    }
}

