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
import Siesta

class NetworkStub: NetworkingProvider {
  func enqueue(response block: () -> ResponseStub) {
    responses.append(block())
  }

  // MARK: - NetworkingProvider
  var responses: [ResponseStub] = []
  func startRequest(
    _ request: URLRequest,
    completion: @escaping RequestNetworkingCompletionCallback
  ) -> RequestNetworking {
    let response = responses.removeFirst()
    var headers: [String: String] = [:]
    headers["content-type"] = response.contentType
    let metadata = HTTPURLResponse(
      url: request.url!,
      statusCode: response.status,
      httpVersion: "HTTP/1.1",
      headerFields: headers
    )

    completion(metadata, response.data, nil)
    return FakeRequest()
  }
}

struct ResponseStub {
  var contentType: String
  var status: Int
  var data: Data
}

struct FakeRequest: RequestNetworking {
  func cancel() {}

  var transferMetrics: RequestTransferMetrics {
    return RequestTransferMetrics(
      requestBytesSent: 0,
      requestBytesTotal: nil,
      responseBytesReceived: 0,
      responseBytesTotal: nil
    )
  }
}

class TestObserver: ResourceObserver {
  var events: [Resource: [ResourceEvent]] = [:]
  func resourceChanged(_ resource: Resource, event: ResourceEvent) {
    if var es = events[resource] {
      es.append(event)
    } else {
      events[resource] = [event]
    }
  }
}
