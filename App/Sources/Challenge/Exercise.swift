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

struct Exercise: Codable {
  let id: String
  let name: String
  let desc: String
  let goal = "" // todo
  
  var level: String { String(id.first!) }
}

struct Level: Codable {
  let id: String
  let desc: String
  let count: Int
}