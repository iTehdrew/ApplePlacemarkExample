//
//  ViewController.swift
//  ApplePlacemarkExample
//
//  Copyright © 2019 Andrew Konovalskiy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

final class ViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var searchBar: UISearchBar!
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private let request = MKLocalSearch.Request()
    private var localSearch: MKLocalSearch?
    private var region = MKCoordinateRegion()
    private var searchText: String = ""
    private var placemarks = [Placemark]()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placemarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = placemarks[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = item.locationName
        cell.detailTextLabel?.text = item.thoroughfare
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        localSearch?.cancel()
        self.searchText = searchText
        
        request.naturalLanguageQuery = searchText
        request.region = region
        localSearch = MKLocalSearch(request: request)
        localSearch?.start { [weak self] searchResponse, _ in
            
            guard let items = searchResponse?.mapItems else {
                return
            }
            
            self?.placemarks = items.map { Placemark(item: $0) }
            print(items)
            self?.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = ""
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let lastLocation = locations.last else {
            return
        }
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        region = MKCoordinateRegion(center: lastLocation.coordinate, span: span)
    }
}
