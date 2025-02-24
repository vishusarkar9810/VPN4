//
//  BoardingCollectionCell.swift
//  VPN
//
//  Created by Creative on 11/06/24.
//

import UIKit

class BoardingCollectionCell: UICollectionViewCell {

    @IBOutlet weak var _imgView: UIImageView!
    @IBOutlet weak var _titleLbl: UILabel!
    @IBOutlet weak var _descLbl: UILabel!
    
    class var height : CGFloat { 300.0 }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupData(_ data : infoData)
    {
        _titleLbl.text =  data.title
        _descLbl.text = data.Desc
        _imgView.image = data.mainImage
        
    }
}
