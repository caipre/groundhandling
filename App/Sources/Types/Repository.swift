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
  func fetch(exercise: Exercise) -> [Record]
  func save(record: Record) -> Result<Record, Error>
}

class InMemoryRepository: Repository {
  private var records: [Record] = []

  func fetch(exercise: Exercise) -> [Record] {
    return records.filter { $0.exercise == exercise }
  }

  func save(record: Record) -> Result<Record, Error> {
    records.append(record)
    return .ok(record)
  }
}

class UserDefaultsRepository: Repository {
  private let store = UserDefaults.standard

  func fetch(exercise: Exercise) -> [Record] {
    guard let records = store.array(forKey: exercise.id) as? [Record] else { return [] }
    return records
  }

  func save(record: Record) -> Result<Record, Error> {
    var records = store.array(forKey: record.exercise.id) ?? []
    records.append(record)
    store.setValue(records, forKey: record.exercise.id)
    return .ok(record)
  }
}
