//
//  ProfileDetailTableViewController.swift
//  ProfileApp
//
//  Created by jithin varghese on 29/05/20.
//  Copyright © 2020 celo. All rights reserved.
//

import UIKit

class ProfileDetailTableViewController: UITableViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblDateOfBirth: UILabel!
    
    var nameTitle,firstname,lastName,gender,phone,email,dob :String?
    var proimage :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.imageFromURL(urlString: proimage!)
        lblTitle.text = nameTitle
        lblFirstName.text = firstname
        lblLastName.text = lastName
        lblPhone.text = phone
        lblEmail.text = email
        lblDateOfBirth.text = dob

    }

}
