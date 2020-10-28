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

struct Wing: Codable, Equatable {
  let id: String
  let brand: String
  let name: String
  let span: Measurement<UnitLength>?
  let area: Measurement<UnitArea>?

  init(
    id: String = UUID().uuidString,
    brand: String,
    name: String,
    span: Measurement<UnitLength>? = nil,
    area: Measurement<UnitArea>? = nil
  ) {
    self.id = id
    self.brand = brand
    self.name = name
    self.span = span
    self.area = area
  }
}
