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

import Foundation

struct RepositoryFileV1: Codable {
  var version = "v1"
  var modified: Date
  var onboarded: Bool
  var records: [Record]
  var wings: [Wing]

  init(
    onboarded: Bool = false,
    records: [Record] = [],
    wings: [Wing] = []
  ) {
    self.modified = Date()
    self.onboarded = onboarded
    self.records = records
    self.wings = wings
  }
}
