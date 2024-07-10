import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {

    //MARK: - Properties
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //koseleri yuvarlaklastirma
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
}


