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

// todo: reliably write data and properly handle errors
class FilesystemRepository: Repository {
  private static let documents =
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  private static let v1filename = "data.v1.json.lzfse"
  private static var fileurl: URL {
    FilesystemRepository.documents.appendingPathComponent(FilesystemRepository.v1filename)
  }

  private let encoder: JSONEncoder
  private let decoder: JSONDecoder
  private let repository: InMemoryRepository

  init(
    encoder: JSONEncoder,
    decoder: JSONDecoder,
    data: RepositoryDataV1
  ) {
    self.encoder = encoder
    self.decoder = decoder
    self.repository = InMemoryRepository(wing: data.wing, records: data.records)
  }

  func write() {
    let data = RepositoryDataV1(
      wing: repository.wing,
      records: repository.records
    )
    try! write(data: data)
  }

  // MARK: - Repository

  var records: [Record] {
    get { repository.records }
    set { repository.records = newValue }
  }
  var wing: Wing {
    get { repository.wing }
    set { repository.wing = newValue }
  }

  static func create(
    at url: URL = FilesystemRepository.fileurl,
    encoder: JSONEncoder,
    decoder: JSONDecoder,
    wing: Wing
  ) throws -> FilesystemRepository {
    let data = RepositoryDataV1(wing: wing)
    let repository = FilesystemRepository(encoder: encoder, decoder: decoder, data: data)
    try repository.write(at: url, data: data)
    return repository
  }

  static func load(
    at url: URL = FilesystemRepository.fileurl,
    encoder: JSONEncoder,
    decoder: JSONDecoder
  ) throws -> FilesystemRepository? {
    print(url)
    do {
      let datz = try Data(contentsOf: url)
      let data = try datz.decompressed()
      let decoded = try decoder.decode(RepositoryDataV1.self, from: data)
      return FilesystemRepository(encoder: encoder, decoder: decoder, data: decoded)
    } catch is DecodingError {
      fatalError()
    } catch let error as NSError {
      guard error.code == 260 else { fatalError("unexpected error: \(error)") }
      return nil  // error.code=260 implies file not found
    }
  }

  private func write(
    at url: URL = FilesystemRepository.fileurl,
    data: RepositoryDataV1
  ) throws {
    let encoded = try encoder.encode(data)
    let encz = try encoded.compressed()
    try encz.write(to: url, options: .atomicWrite)
  }
}
