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

protocol Repository {
  func fetch(exercise: Exercise) -> [Record]
  func save(record: Record) -> Result<Record, Error>
}

struct Record {
  let id: String
  let date: Date
  let wing: String
  let exercise: Exercise
  let comments: String?

  static func new(wing: String, exercise: Exercise, comments: String? = nil) -> Record {
    let uuid = UUID().uuidString
    return Record(
      id: uuid,
      date: Date(),
      wing: wing,
      exercise: exercise,
      comments: comments
    )
  }
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
