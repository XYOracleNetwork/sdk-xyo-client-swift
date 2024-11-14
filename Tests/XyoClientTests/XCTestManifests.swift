import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        return [
            testCase(BoundWitnessTests.allTests),
            testCase(AddressTests.allTests),
        ]
    }
#endif
