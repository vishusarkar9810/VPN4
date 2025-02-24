//
//  VPNListTableCell.swift
//  VPN
//
//  Created by creative on 10/07/24.
//

import UIKit

class VPNListTableCell: UITableViewCell {

    @IBOutlet weak var _imgView: UIImageView!
    @IBOutlet weak var _countryNameLbl: UILabel!
    @IBOutlet weak var _selectionBtn: UIButton!
    @IBOutlet weak var _goPremiumView: UIVisualEffectView!

    class var height : CGFloat {
        //UITableView.automaticDimension
        60.0
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setup(_ data : VPNModel) {
        _countryNameLbl.text = data.country
        _imgView.loadWebImage(data.image)
        _goPremiumView.isHidden = !data.isPremium
    }
    
}
