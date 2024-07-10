import UIKit

class TopCollectionViewColumnFlowLayout: UICollectionViewFlowLayout {
    
    let columnNumber: Int
    var heightRatio: CGFloat = (1.0 / 3.0)
    
    init(columnNumber: Int, minColSpace: CGFloat = 0, minRowSpace: CGFloat = 0) {
        self.columnNumber = columnNumber
        super.init()
        
        self.minimumInteritemSpacing = minColSpace
        self.minimumLineSpacing = minRowSpace
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        let spacing = collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(columnNumber - 1)
        
        let elementWidth = (collectionView.bounds.size.width - spacing) / CGFloat(columnNumber).rounded(.down) // .rouned(.down) ile asagiya yuvarladik.
        let elementHeight = elementWidth * heightRatio
        
        itemSize = CGSize(width: elementWidth, height: elementHeight)
        
    }
    
}
