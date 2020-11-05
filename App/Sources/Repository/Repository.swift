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
import Kite

protocol Repository {
  var wing: Wing { get set }
  var records: [Record] { get set }
  func write()
}

extension Repository {
  func records(for exercise: Exercise) -> [Record] {
    return records.filter { $0.exerciseId == exercise.id }
  }
}
