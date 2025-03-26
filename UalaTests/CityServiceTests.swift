//
//  UalaTests.swift
//  UalaTests
//
//  Created by Carlos Mario Muñoz on 21/03/25.
//

import XCTest
@testable import Uala

final class CityServiceTests: XCTestCase {

    var service: CityService!

    override func setUp() {
        super.setUp()
        service = CityService()
        URLProtocol.registerClass(URLProtocolMock.self)
    }

    override func tearDown() {
        URLProtocol.unregisterClass(URLProtocolMock.self)
    }

    func test_fetchCities_returnsParsedData() async throws {
        let mockCities = [City(id: 1, country: "AR", name: "CABA", coord: .init(lat: 1.0, lon: 1.0))]
        let data = try JSONEncoder().encode(mockCities)

        URLProtocolMock.responseData = data
        URLProtocolMock.responseStatusCode = 200

        let cities = try await service.fetchCities()
        XCTAssertEqual(cities.count, 1)
        XCTAssertEqual(cities.first?.name, "CABA")
    }
}

class URLProtocolMock: URLProtocol {
    static var responseData: Data?
    static var responseStatusCode: Int = 200

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        if let data = Self.responseData {
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: Self.responseStatusCode,
                httpVersion: nil,
                headerFields: nil
            )!
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
