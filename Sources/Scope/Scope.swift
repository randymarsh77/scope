import IDisposable

public typealias DisposeFunc = () -> ()

public class Scope: IDisposable {
	var disposeFunc: DisposeFunc? = nil

	public init(dispose: DisposeFunc?) {
		disposeFunc = dispose
	}

	public func dispose() {
		disposeFunc?()
		disposeFunc = nil
	}

	public func transfer() -> Scope {
		let newScope = Scope(dispose: disposeFunc)
		disposeFunc = nil
		return newScope
	}
}
