//
//  ProfileListViewController.swift
//  ProfileApp
//
//  Created by jithin varghese on 28/05/20.
//  Copyright © 2020 celo. All rights reserved.
//

import UIKit
import CoreData

class ProfileListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    //    Coredata object
    var coreDataProfile: [NSManagedObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if getRecordsCount() > 0 {
            let pageNo = (getRecordsCount()/Constant.resultPerPage)
            UserDefaults.standard.set(String(pageNo+1), forKey: Constant.pageNo)
            NetworkManager().fetchData { (userProfile) in
                if let profileLists = userProfile {
                    for profileList in profileLists.results{
                        self.saveToCoreData(profileData:profileList)
                        print(profileList)
                        
                    }
                }
            }
        } else {
            UserDefaults.standard.set("1", forKey: Constant.pageNo)
            NetworkManager().fetchData { (userProfile) in
                if let profileLists = userProfile {
                    for profileList in profileLists.results {
                        self.saveToCoreData(profileData:profileList)
                        print(profileList)
                    }
                }
            }
       }
      self.fetchCoreData()
      searchBar.delegate = self
      self.title = "Profile List"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func getRecordsCount() -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constant.entitiesName)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return 0
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            var count :Int
            count = try managedContext.count(for: fetchRequest)
            print(count)
            return count
            
        } catch {
            print(error.localizedDescription)
        }
        return 0
    }
    func fetchCoreData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constant.entitiesName)
        
        do {
            coreDataProfile = try managedContext.fetch(fetchRequest)
            //            for user in coreDataProfile{
            //                user.value(forKeyPath: "first") as! String
            //                user.value(forKeyPath: "thumbnail") as! String
            //
            //            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func saveToCoreData(profileData: Results) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: Constant.entitiesName,
                                                in: managedContext)!
        
        let profile = NSManagedObject(entity: entity, insertInto: managedContext)
        
        
        profile.setValue(profileData.name.first, forKeyPath: "first")
        profile.setValue(profileData.picture.thumbnail, forKeyPath: "thumbnail")
        profile.setValue(profileData.picture.large, forKeyPath: "large")
        profile.setValue(profileData.dob.date, forKeyPath: "dob")
        profile.setValue(profileData.email, forKeyPath: "email")
        profile.setValue(profileData.gender, forKeyPath: "gender")
        profile.setValue(profileData.phone, forKeyPath: "phone")
        profile.setValue(profileData.name.title, forKeyPath: "title")
        profile.setValue(profileData.name.last, forKeyPath: "last")
        
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfRows(inSection section: Int) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        if (self.coreDataProfile.count > 0){
            return coreDataProfile.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let profile = coreDataProfile[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId",for: indexPath) as! ProfileTableViewCell
        
        var lbltitle = profile.value(forKeyPath: "title") as? String
        var  lblfirstName = profile.value(forKeyPath: "first") as? String
        if let  lastName = profile.value(forKeyPath: "last") as? String{
            cell.lblName.text =  lbltitle! + " " + lblfirstName! + " " + lastName
        }
        
        if let gender = profile.value(forKeyPath: "gender") as? String{
            cell.lblGender.text = "Gender: "+gender
        }
        if let imageURL = profile.value(forKeyPath: "thumbnail") as? String{
            cell.profileImage.imageFromURL(urlString:imageURL)
        }
        
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        let date = dateFormatter.date(from:((profile.value(forKeyPath: "dob") as? String)!))!
        dateFormatter.dateFormat = "d-MMM-yyyy"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        cell.lblDateOfBirth.text = "DOB: " + dateString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profile = coreDataProfile[indexPath.row]
        let storboard = UIStoryboard.init(name:"Main", bundle: nil)
        let objProfileDetails = storboard.instantiateViewController(withIdentifier:"ProfileDetails") as! ProfileDetailTableViewController
        if let title = (profile.value(forKeyPath: "title") as? String){
            objProfileDetails.nameTitle = title
        }
        objProfileDetails.proimage = profile.value(forKeyPath: "large") as? String
        objProfileDetails.firstname = profile.value(forKeyPath: "first") as? String
        objProfileDetails.lastName = profile.value(forKeyPath: "last") as? String
        objProfileDetails.gender = profile.value(forKeyPath: "gender") as? String
        objProfileDetails.phone = profile.value(forKeyPath: "phone") as? String
        objProfileDetails.email = profile.value(forKeyPath: "email") as? String
        
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        let date = dateFormatter.date(from:((profile.value(forKeyPath: "dob") as? String)!))!
        dateFormatter.dateFormat = "d-MMM-yyyy"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        objProfileDetails.dob = dateString

        navigationController?.pushViewController(objProfileDetails, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != ""{
            
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constant.entitiesName)
            var predicate: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "first CONTAINS[c] '\(searchText)'")
            fetchRequest.predicate = predicate
            do{
                
                coreDataProfile = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            }
            catch{
                print("error in loading data")
            }
        }
        else{
            fetchCoreData()
        }
        tableView.reloadData()
    }
}

extension UIImageView {
    public func imageFromURL(urlString: String) {
        
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        activityIndicator.startAnimating()
        if self.image == nil{
            self.addSubview(activityIndicator)
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                activityIndicator.removeFromSuperview()
                self.image = image
            })
            
        }).resume()
    }
    
    
}
