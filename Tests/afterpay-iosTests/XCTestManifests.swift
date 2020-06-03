import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(afterpay_iosTests.allTests),
    ]
}
#endif
