//  Copyright (C) 2020 Nick Platt <platt.nicholas@gmail.com>
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 2 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.

import Combine
import CoreLocation
import Foundation

class LocationService: NSObject {
  @Published public private(set) var placemark: Placemark?
  @Published public private(set) var authorizationStatus: CLAuthorizationStatus = .notDetermined

  private lazy var manager: CLLocationManager = { CLLocationManager() }()
  private lazy var geocoder: CLGeocoder = { CLGeocoder() }()

  func start() {
    guard CLLocationManager.significantLocationChangeMonitoringAvailable() else { return }
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    manager.startMonitoringSignificantLocationChanges()
  }

  func requestAuth() {
    guard authorizationStatus == .notDetermined else { return }
    manager.requestWhenInUseAuthorization()
  }

  func stop() {
    manager.stopMonitoringSignificantLocationChanges()
  }
}

extension LocationService: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    authorizationStatus = manager.authorizationStatus
    switch manager.authorizationStatus {
    case .restricted, .denied:
      manager.stopMonitoringSignificantLocationChanges()
    default:
      break
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    geocoder.reverseGeocodeLocation(location) { (marks: [CLPlacemark]?, error: Error?) in
      guard let mark = marks?.last else { return }
      if let coordinate = mark.location?.coordinate,
        let administrativeArea = mark.administrativeArea,
        let locality = mark.locality
      {
        self.placemark = Placemark(
          latitude: coordinate.latitude,
          longitude: coordinate.longitude,
          administrativeArea: administrativeArea,
          locality: locality
        )
      }
    }
  }
}
