import XCTest

@testable import Scope

class ScopeTests: XCTestCase {
	// Dispose should nil the callback
	func testDisposeCleanup() {
		let scope = Scope {}
		scope.dispose()
		XCTAssertNil(scope.disposeFunc)
	}

	// Dispose should call the callback
	func testDispose() {
		var x = 0
		let scope = Scope {
			x += 1
		}
		scope.dispose()
		XCTAssertEqual(x, 1)
		scope.dispose()
		XCTAssertEqual(x, 1, "Multiple Dispose should be safe, but a noop")
	}

	// Transfer should create a new scope with the same callback,
	// leaving the original scope without a callback
	func testTransfer() {
		var x = 0
		let scope = Scope {
			x += 1
		}
		let transferred = scope.transfer()
		scope.dispose()
		XCTAssertEqual(x, 0, "Scope should have been transferred")
		transferred.dispose()
		XCTAssertEqual(x, 1, "Transferred scope should call the original callback")
	}
}
