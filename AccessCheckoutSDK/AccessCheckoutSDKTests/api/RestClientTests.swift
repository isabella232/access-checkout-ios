@testable import AccessCheckoutSDK
import Foundation
import Mockingjay
import XCTest

class RestClientTests: XCTestCase {
    private let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    private let restClient = RestClient()

    override func tearDown() {
        removeAllStubs()
    }

    func testRestClientSendsRequest() {
        let request = createRequest(url: "http://localhost/somewhere", method: "GET")
        let urlSessionDataTaskMock: URLSessionDataTaskMock = URLSessionDataTaskMock()
        let urlSession: URLSessionMock = URLSessionMock(forRequest: request, usingDataTask: urlSessionDataTaskMock)

        restClient.send(urlSession: urlSession, request: request, responseType: DummyResponse.self) { _ in }

        XCTAssertTrue(urlSession.dataTaskCalled)
        XCTAssertTrue(urlSessionDataTaskMock.resumeCalled)
    }

    func testRestClientCanReturnSuccessfulResponse() {
        let expectationToWaitFor = XCTestExpectation(description: "")
        let request = createRequest(url: "http://localhost/somewhere", method: "GET")
        stub(http(.get, uri: "http://localhost/somewhere"), jsonData(toData("{\"id\":1, \"name\":\"some name\"}"), status: 200))

        restClient.send(urlSession: urlSession, request: request, responseType: DummyResponse.self) { result in
            switch result {
                case .success(let response):
                    XCTAssertEqual(1, response.id)
                    XCTAssertEqual("some name", response.name)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }
            expectationToWaitFor.fulfill()
        }

        wait(for: [expectationToWaitFor], timeout: 1)
    }

    func testRestClientCanReturnError() {
        let expectationToWaitFor = XCTestExpectation(description: "")
        let request = createRequest(url: "http://localhost/somewhere", method: "GET")
        stub(http(.get, uri: "http://localhost/somewhere"), jsonData(toData("""
            {
                "errorName": "bodyDoesNotMatchSchema",
                "message": "The json body provided does not match the expected schema",
                "validationErrors": [{
                  "errorName": "fieldHasInvalidValue",
                  "message": "Cvc is invalid",
                  "jsonPath": "$.cvc"
                }]
            }
        """), status: 400))

        restClient.send(urlSession: urlSession, request: request, responseType: DummyResponse.self) { result in
            switch result {
                case .success:
                    XCTFail("Expected failed response but received successful response")
                case .failure(let error):
                    XCTAssertEqual("bodyDoesNotMatchSchema : The json body provided does not match the expected schema", error.message)
            }
            expectationToWaitFor.fulfill()
        }

        wait(for: [expectationToWaitFor], timeout: 1)
    }

    func testRestClientProvidesGenericErrorToPromiseWhenFailingToTranslateResponse() {
        let expectationToWaitFor = XCTestExpectation(description: "")
        let expectedError = StubUtils.createError(errorName: "responseDecodingFailed", message: "Failed to decode response data")
        let request = createRequest(url: "http://localhost/somewhere", method: "GET")
        stub(http(.get, uri: "http://localhost/somewhere"), jsonData(toData("some data returned"), status: 200))

        restClient.send(urlSession: urlSession, request: request, responseType: DummyResponse.self) { result in
            switch result {
                case .success:
                    XCTFail("Expected failed response but received successful response")
                case .failure(let error):
                    XCTAssertEqual(expectedError, error)
            }
            expectationToWaitFor.fulfill()
        }

        wait(for: [expectationToWaitFor], timeout: 1)
    }

    func testRestClientProvidesGenericErrorToPromiseWhenFailingToGetAResponse() {
        let expectationToWaitFor = XCTestExpectation(description: "")
        let request = createRequest(url: "http://localhost/somewhere", method: "GET")
        // On BitRise, the message returned when attempting to connect to an unknown host may occasionally be different
        // Hence why we need to assert on different error messages
        let expectedError1 = StubUtils.createError(errorName: "unexpectedApiError", message: "Could not connect to the server.")
        let expectedError2 = StubUtils.createError(errorName: "unexpectedApiError", message: "A server with the specified hostname could not be found.")

        restClient.send(urlSession: urlSession, request: request, responseType: DummyResponse.self) { result in
            switch result {
                case .success:
                    XCTFail("Expected failed response but received successful response")
                case .failure(let error):
                    XCTAssert(error == expectedError1 || error == expectedError2)
            }
            expectationToWaitFor.fulfill()
        }

        wait(for: [expectationToWaitFor], timeout: 1)
    }

    private func createRequest(url: String, method: String) -> URLRequest {
        let urlInstance: URL? = URL(string: url)
        var request = URLRequest(url: urlInstance!)
        request.httpMethod = method
        return request
    }

    private func toData(_ stringData: String) -> Data {
        return stringData.data(using: .utf8)!
    }

    class DummyResponse: Codable {
        var id: Int
        var name: String
    }
}
