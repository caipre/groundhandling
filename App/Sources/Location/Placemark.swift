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

import CoreLocation
import Foundation

struct Placemark: Codable {
  let latitude: CLLocationDegrees
  let longitude: CLLocationDegrees
  let administrativeArea: String
  let locality: String

  var coordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }

  init(
    latitude: CLLocationDegrees,
    longitude: CLLocationDegrees,
    administrativeArea: String,
    locality: String
  ) {
    self.latitude = latitude
    self.longitude = longitude
    self.administrativeArea = administrativeArea
    self.locality = locality
  }
}
