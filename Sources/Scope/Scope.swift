import IDisposable

public typealias DisposeFunc = @Sendable () async -> Void

@available(iOS 13.0.0, *)
@available(macOS 10.15.0, *)
public final actor Scope: Sendable, IAsyncDisposable {
	public var isDisposed = false
	private let disposeFunc: DisposeFunc?

	public init(dispose: DisposeFunc?) {
		disposeFunc = dispose
	}

	public func dispose() async {
		if (isDisposed) {
			return;
		}

		isDisposed = true
		await disposeFunc?()
	}

	public func transfer() -> Scope {
		let newScope = Scope(dispose: disposeFunc)
		isDisposed = true
		return newScope
	}
}
