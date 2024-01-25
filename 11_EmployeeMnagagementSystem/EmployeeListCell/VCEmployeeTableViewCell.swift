//
//  VCEmployeeTableViewCell.swift
//  11_EmployeeMnagagementSystem
//
//  Created by MacBook Pro on 11/01/24.
//

import UIKit

class VCEmployeeTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var designationLabel: UILabel!
    @IBOutlet var imageUI: UIView!
    @IBOutlet var empImageView: UIImageView!
    @IBOutlet var details: UIButton!
    @IBOutlet var edit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageUI.layer.cornerRadius = imageUI.frame.width / 2
        empImageView.layer.cornerRadius = empImageView.frame.width / 2
        empImageView.contentMode = .scaleToFill
        
        details.setTitle("", for: .normal)
        edit.setTitle("", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
