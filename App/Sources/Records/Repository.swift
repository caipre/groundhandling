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
  var onboarded: Bool { get }
  func setOnboarded(to: Bool)

  func fetchRecords(for exercise: Exercise) -> [Record]
  func save(record: Record) -> Result<Record, Error>

  func fetchWings() -> [Wing]
  func save(wing: Wing) -> Result<Wing, Error>
}

class InMemoryRepository: Repository {
  public private(set) var onboarded: Bool
  fileprivate var records: [Record]
  fileprivate var wings: [Wing]

  init(
    onboarded: Bool = false,
    records: [Record] = [],
    wings: [Wing] = []
  ) {
    self.onboarded = onboarded
    self.records = records
    self.wings = wings
  }

  func setOnboarded(to onboarded: Bool) {
    self.onboarded = onboarded
  }

  func fetchRecords(for exercise: Exercise) -> [Record] {
    return records.filter { $0.exerciseId == exercise.id }
  }

  func save(record: Record) -> Result<Record, Error> {
    records.append(record)
    return .ok(record)
  }

  func fetchWings() -> [Wing] {
    return wings
  }

  func save(wing: Wing) -> Result<Wing, Error> {
    wings.append(wing)
    return .ok(wing)
  }
}

// todo: reliably write data and properly handle errors
class FileSystemRepository: Repository {
  private static let documents = FileManager.default.urls(
    for: .documentDirectory,
    in: .userDomainMask
  ).first!
  private static let v1filename = "data.v1.json"

  private static let encoder = JSONEncoder()
  private static let decoder = JSONDecoder()

  private let fileurl: URL

  private let repository: InMemoryRepository

  init() {
    fileurl = FileSystemRepository.documents.appendingPathComponent(FileSystemRepository.v1filename)

    let loaded = try! FileSystemRepository.load(at: fileurl)
    repository = InMemoryRepository(
      onboarded: loaded.onboarded,
      records: loaded.records,
      wings: loaded.wings
    )
  }

  var onboarded: Bool {
    repository.onboarded
  }

  func setOnboarded(to: Bool) {
    repository.setOnboarded(to: to)
  }

  func fetchRecords(for exercise: Exercise) -> [Record] {
    return repository.fetchRecords(for: exercise)
  }

  func save(record: Record) -> Result<Record, Error> {
    return repository.save(record: record)
  }

  func fetchWings() -> [Wing] {
    return repository.fetchWings()
  }

  func save(wing: Wing) -> Result<Wing, Error> {
    return repository.save(wing: wing)
  }

  // private

  private static func create(at url: URL) throws -> RepositoryFileV1 {
    return try FileSystemRepository.write(at: url, data: RepositoryFileV1())
  }

  private static func load(at url: URL) throws -> RepositoryFileV1 {
    do {
      let data = try Data(contentsOf: url)
      return try FileSystemRepository.decoder.decode(RepositoryFileV1.self, from: data)
    } catch is DecodingError {
      fatalError()
    } catch {
      return try FileSystemRepository.create(at: url)
    }
  }

  private static func write(at url: URL, data: RepositoryFileV1) throws -> RepositoryFileV1 {
    print(url)
    let encoded = try FileSystemRepository.encoder.encode(data)
    try encoded.write(to: url, options: .atomicWrite)
    return data
  }

  func flush() {
    let data = RepositoryFileV1(
      onboarded: repository.onboarded,
      records: repository.records,
      wings: repository.wings
    )
    try! FileSystemRepository.write(at: fileurl, data: data)
  }
}
