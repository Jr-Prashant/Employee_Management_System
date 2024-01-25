//
//  ProfilePhotoViewController.swift
//  11_EmployeeMnagagementSystem
//
//  Created by MacBook Pro on 12/01/24.
//

import UIKit

class ProfilePhotoViewController: UIViewController {
    
    @IBOutlet var viewImage: UIImageView!
    @IBOutlet var noPhotoLabel: UILabel!
    var image : UIImage?
    var flag: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(flag == 0){
            self.noPhotoLabel.isHidden = false
            self.viewImage.isHidden = true
            view.alpha = 0.7
        } else {
            self.noPhotoLabel.isHidden = true
        }
        viewImage.image = image
        navigationController?.isNavigationBarHidden = true
        
    }
    
    // It'll call when view has been added to the view hierarchy
    override func viewDidAppear(_ animated: Bool) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tap)
    }
    
    // Handle the tap gesture here
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // Hide the navigation bar only for this view controller
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // Show the navigation bar again when leaving this view controller
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}
