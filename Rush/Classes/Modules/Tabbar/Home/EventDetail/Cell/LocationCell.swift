//
//  LocationCell.swift
//  Rush
//
//  Created by kamal on 04/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import MapKit

class LocationCell: UITableViewCell {

    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationLabel: CustomBlackLabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    let downloadQueue = DispatchQueue(label: "com.messapps.locationImage")
    let downloadGroup = DispatchGroup()
    var showLocationOnMap: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - Actions
extension LocationCell {
    @IBAction func showLocation() {
       showLocationOnMap?()
    }
}

// MARK: - Data Functions
extension LocationCell {
    
    func set(address: String, lat: String, lon: String) {
        locationLabel.text = address
        let key = lat + lon
        if Utils.isFileExist(key) {
            let path = Utils.getPathForFileName(key)
            loadImage(path: path)
        } else {
            spinner.startAnimating()
            if let latitude = Double(lat), let longitude = Double(lon) {
                downloadQueue.async {
                    let time = DispatchTime.now() + (2 * 60)
                    _ = self.downloadGroup.wait(timeout: time)
                    self.downloadGroup.enter()
                    if Utils.isFileExist(key) {
                        DispatchQueue.main.async {
                            let path = Utils.getPathForFileName(key)
                            self.loadImage(path: path)
                            self.spinner.stopAnimating()
                        }
                    } else {
                        self.imageFromLocation(lat: latitude, lon: longitude) { image in
                            DispatchQueue.main.async {
                                self.locationImageView.image = image
                                self.spinner.stopAnimating()
                            }
                            
                            if let createdImage = image {
                               _ = Utils.saveImageInApp(key, createdImage)
                            }
                            self.downloadGroup.leave()
                        }
                    }
                }
            } else {
                self.locationImageView.image = nil
            }
        }
    }
    
    func loadImage(path: String) {
        do {
            let filePath = URL(fileURLWithPath: path)
            let imageData = try Data(contentsOf: filePath)
            locationImageView.image = UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
    }
}

// MARK: - Private
extension LocationCell {

    private func imageFromLocation(lat: Double, lon: Double, handler: @escaping (_ image: UIImage?) -> Void) {
        
        let mapSnapshotOptions = MKMapSnapshotter.Options()
        
        // Set the region of the map that is rendered.
        let location = CLLocationCoordinate2DMake(lat, lon)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 500, longitudinalMeters: 500)
        mapSnapshotOptions.region = region
        
        // Set the scale of the image. We'll just use the scale of the current device, which is 2x scale on Retina screens.
        mapSnapshotOptions.scale = UIScreen.main.scale
        
        // Set the size of the image output.
        mapSnapshotOptions.size = locationImageView.frame.size

        // Show buildings and Points of Interest on the snapshot
        mapSnapshotOptions.showsBuildings = true
        mapSnapshotOptions.showsPointsOfInterest = true
        
        let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        snapShotter.start(with: DispatchQueue.global()) { (snapshot, _) in
            if let image = snapshot?.image {
                handler(image)
            } else {
                handler(nil)
            }
        }
    }
    
}
