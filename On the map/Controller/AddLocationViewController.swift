//
//  AddLocationViewController.swift
//  On the map
//
//  Created by Bashayer AlGhamdi on 29/04/1440 AH.
//  Copyright © 1440 Bashayer. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaLinkTextField: UITextField!
    @IBOutlet weak var inform: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.cancelTapped(_:)))
    }
    
    
    
    @IBAction func findLocationTapped(_ sender: UIButton) {
        guard let location = locationTextField.text,
            let mediaLink = mediaLinkTextField.text,
            location != "", mediaLink != "" else {
                inform.text = "Please fill both fields and try again"
                return }
        
        

        let studentLocation = StudentInformation(mapString1: location, mediaURL1: mediaLink)
        geocodeCoordinates(studentLocation)
    }
    
    private func geocodeCoordinates(_ studentLocation: StudentInformation) {
        
        let ai = self.startAnActivityIndicator()
        
        CLGeocoder().geocodeAddressString(studentLocation.mapString!) { (placeMarks, err) in
            ai.stopAnimating()
            guard let firstLocation = placeMarks?.first?.location else { return }
            var location = studentLocation
            location.latitude = firstLocation.coordinate.latitude
            location.longitude = firstLocation.coordinate.longitude
            
            self.performSegue(withIdentifier: "mapSegue", sender: location)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue", let vc = segue.destination as? ConfirmLocationViewController {
            vc.location = (sender as! StudentInformation)
        }
    }
    
    @objc private func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func startAnActivityIndicator() -> UIActivityIndicatorView {
        let ai = UIActivityIndicatorView(style: .gray)
        self.view.addSubview(ai)
        self.view.bringSubviewToFront(ai)
        ai.center = self.view.center
        ai.hidesWhenStopped = true
        ai.startAnimating()
        return ai
    }
    
}


