import XCTest

@testable import Scope

actor Counter: Sendable
{
	var value = 0

	public func increment() {
		value += 1
	}

	public func getValue() -> Int {
		return value
	}
}

class ScopeTests: XCTestCase {
	// Dispose should set isDisposed
	func testDisposeCleanup() async {
		let scope = Scope {}
		await scope.dispose()
		let isDisposed = await scope.isDisposed
		XCTAssertTrue(isDisposed)
	}

	// Dispose should call the callback
	func testDispose() async {
		let counter = Counter()
		let scope = Scope {
			await counter.increment()
		}
		await scope.dispose()
		let firstValue = await counter.getValue()
		XCTAssertEqual(firstValue, 1)
		await scope.dispose()
		let secondValue = await counter.getValue()
		XCTAssertEqual(secondValue, 1, "Multiple Dispose should be safe, but a noop")
	}

	// Transfer should create a new scope with the same callback,
	// leaving the original scope without a callback
	func testTransfer() async {
		let counter = Counter()
		let scope = Scope {
			await counter.increment()
		}
		let transferred = await scope.transfer()
		await scope.dispose()
		let firstValue = await counter.getValue()
		XCTAssertEqual(firstValue, 0, "Scope should have been transferred")
		await transferred.dispose()
		let secondValue = await counter.getValue()
		XCTAssertEqual(secondValue, 1, "Transferred scope should call the original callback")
	}
}
