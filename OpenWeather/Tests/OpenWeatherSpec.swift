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
import Nimble
import Quick
import Siesta

@testable import OpenWeather

final class OpenWeatherSpec: QuickSpec {
  private static let appId = "0xdeadbeef"
  private static let decoder = JSONDecoder()

  override func spec() {


    var example: Data!

    beforeSuite {
      example =
        try! Data(
          contentsOf: Bundle.module.url(
            forResource: "example-response",
            withExtension: "json"
          )!
        )
    }


    describe("OpenWeather") {
      var network: NetworkStub!
      var service: Service!
      var client: OpenWeather!

      beforeEach {
        network = NetworkStub()
        service = Service(baseURL: "tcp://localhost", networking: network)
        client = OpenWeather.init(
          decoder: OpenWeatherSpec.decoder,
          service: service,
          appId: OpenWeatherSpec.appId
        )
      }

      describe("Current Weather API") {
        it("supports city names") {
          network.enqueue {
            ResponseStub(contentType: "type/json", status: 200, data: example)
          }
          let resource = client.city(name: "Mountain View", state: "CA")
          resource.loadIfNeeded()
          waitUntil { done in
            resource.addObserver(owner: self) { r, e in
              if case .newData(_) = e {
                guard let response: CurrentWeatherResponse = r.typedContent() else { return }
                expect(response.name).to(equal("Mountain View"))
                done()
              }
            }
          }
        }

        it("supports lat/lon coords") {
          network.enqueue {
            ResponseStub(contentType: "type/json", status: 200, data: example)
          }
          let resource = client.coord(lat: 44.48048, lon: -73.06002)
          resource.loadIfNeeded()
          waitUntil { done in
            resource.addObserver(owner: self) { r, e in
              if case .newData(_) = e {
                guard let response: CurrentWeatherResponse = r.typedContent() else { return }
                expect(response.name).to(equal("Mountain View"))
                done()
              }
            }
          }
        }
      }
    }
  }
}
