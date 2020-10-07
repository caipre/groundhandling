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

struct Record: Codable {
  let id: String
  let date: Date
  let exerciseId: ExerciseId
  let wing: Wing
  let placemark: Placemark?
  let windSpeed: Measurement<UnitSpeed>?
  let windAngle: Measurement<UnitAngle>?
  let temperature: Measurement<UnitTemperature>?
  let comment: String?

  init(
    id: String = UUID().uuidString,
    date: Date = Date(),
    exerciseId: ExerciseId,
    wing: Wing,
    placemark: Placemark? = nil,
    windSpeed: Measurement<UnitSpeed>? = nil,
    windAngle: Measurement<UnitAngle>? = nil,
    temperature: Measurement<UnitTemperature>? = nil,
    comment: String? = nil
  ) {
    self.id = id
    self.date = date
    self.exerciseId = exerciseId
    self.wing = wing
    self.placemark = placemark
    self.windSpeed = windSpeed
    self.windAngle = windAngle
    self.temperature = temperature
    self.comment = comment
  }
}
