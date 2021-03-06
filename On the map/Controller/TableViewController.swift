//
//  TableViewController.swift
//  On the map
//
//  Created by Bashayer AlGhamdi on 29/04/1440 AH.
//  Copyright © 1440 Bashayer. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var tableOfLocations: UITableView!
    var locationsData: [StudentInformation]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        locationsData?.removeAll()
        Parser.getStudentLocations { (locations) in
            
            DispatchQueue.main.async {
                
                guard locations != nil else {
                    let errorAlert = UIAlertController(title: "Erorr performing request", message: "There was an error performing your request", preferredStyle: .alert )
                    errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                    return
                }
                
                guard let locations = locations?.LocationsArray else { return }
                self.locationsData = locations
                
                self.tableOfLocations.reloadData();
            }
        }//end getAllLocations
        
    }

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsData?.count ?? 0

    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = self.locationsData?[indexPath.row]
        let cell = tableOfLocations.dequeueReusableCell(withIdentifier: "pin", for: indexPath)
        
        
        cell.imageView?.image = UIImage(named: "icon-pin")
        cell.textLabel?.text = "\(student?.firstName ?? "") \(student?.lastName ?? "")"
        cell.detailTextLabel?.text = student?.mediaURL
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // check the validity
        let app = UIApplication.shared
        if let toOpen = locationsData?[indexPath.row].mediaURL,
            let url = URL(string: toOpen), app.canOpenURL(url) {
            app.open(url, options: [:], completionHandler: nil)
        }else{
            let alertController = UIAlertController(title: "Error", message: "The link is invalid!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
    }
    
    
    func setupUI() {
        
        let AddButton = UIBarButtonItem(image: UIImage(named: "icon_addpin"), style: .plain, target: self, action: #selector(self.addLocationTapped(_:)))

        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logoutTapped(_:)))
        
        navigationItem.rightBarButtonItem = AddButton
        navigationItem.leftBarButtonItem = logoutButton
    }
    
    
    @objc private func addLocationTapped(_ sender: Any) {
        let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddLocationNavigationController") as! UINavigationController
        
        present(navController, animated: true, completion: nil)
    }
    
    @objc private func logoutTapped(_ sender: Any) {
        API.deleteSession { (data) in
            self.dismiss(animated: true, completion: nil)
        }
    }

}
