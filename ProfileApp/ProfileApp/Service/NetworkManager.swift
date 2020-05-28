//
//  NetworkManager.swift
//  ProfileApp
//
//  Created by jithin varghese on 28/05/20.
//  Copyright © 2020 celo. All rights reserved.
//

import Foundation

class NetworkManager{
    
    func fetchData(completion: @escaping (UserProfile?) -> ()){
        
        if let pageNo = UserDefaults.standard.string(forKey: Constant.pageNo){
            let urlString = Constant.baseURL + String(Constant.resultPerPage) + "&page=" + pageNo;
            
            guard let url = URL(string: urlString) else {completion(nil)
                return
            }
            
            URLSession.shared.dataTask(with: url) { (data, resp, err) in
                if let err = err {
                    
                    print("Failed to fetch courses:", err)
                    completion(nil)
                    return
                }
                
                guard let data = data else {completion(nil)
                    return }
                do {
                    let userprofiles = try JSONDecoder().decode(UserProfile.self, from: data)
                    
                    completion(userprofiles)
                    
                    
                } catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                }
            }.resume()
        }
    }
}
