import UIKit

class MainView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.text = "SomeSay"
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }()
    
    var cardsCollection: UICollectionView = {
        let layout = PagingFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 36, bottom: 0, right: 36*3)
        layout.minimumLineSpacing = 24
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(VoiceCardCell.self, forCellWithReuseIdentifier: VoiceCardCell.description())
        view.backgroundColor = .clear
        view.decelerationRate = .fast
        view.showsHorizontalScrollIndicator = false

        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .fromHex(hex: 0x111112)
        
        addSubview(titleLabel)
        addSubview(cardsCollection)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    private func layout() {
        titleLabel.frame = CGRect(x: 0, y: safeAreaInsets.top + 12, width: bounds.width, height: 40)
        cardsCollection.frame = CGRect(x: 0, y: bounds.height/2 - (bounds.height/1.7)/2, width: bounds.width, height: bounds.height/1.7)
    }
    
}
