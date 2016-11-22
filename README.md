# scope
Facilitates cleanup of arbitrary resources, handling multi-ownership concerns.

[![license](https://img.shields.io/github/license/mashape/apistatus.svg)]()
[![GitHub release](https://img.shields.io/github/release/randymarsh77/scope.svg)]()
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Build Status](https://api.travis-ci.org/randymarsh77/scope.svg?branch=master)](https://travis-ci.org/randymarsh77/scope)
[![codecov.io](https://codecov.io/gh/randymarsh77/scope/branch/master/graphs/badge.svg)](https://codecov.io/gh/randymarsh77/scope/branch/master)
[![codebeat badge](https://codebeat.co/badges/2571371c-3b3b-4304-b4df-4f04384dcd5c)](https://codebeat.co/projects/github-com-randymarsh77-scope)


## Usage

`Scope` is `IDisposable` and initialized with a callback that is called on `dispose`. `Scope` also exposes a `transfer` method when ownership needs to be transferred.

```
let scope = Scope {
  print("Disposing!")
}

let transferred = scope.transfer()
scope.dispose() // Does nothing
transferred.dispose() // Prints 'Disposing!'
```

## Example

Consider an object that generates data, lets call this the generator. Consider an object that cares about that data, and wants to subscribe to changes, lets call this the subscriber.

Lets say that the generator has a finite lifetime that may or may not end before with the subscribers lifetime ends.

If we're implementing the generator to have references to all subscribers so that it can execute a callback on a data change, then we need to clean that up when the generator goes out of scope. If a subscriber needs to go out of scope, it should clean itself up from the generator. Now, lets do this without injecting the subscriber with any dependent knowledge of the generator other than a subscribe method.

In this example, `Subscriber` is private to `Generator`, and `Consumer` is the object that subscribes and consumes the data.

```
class Consumer : IDisposable
{
	public init(_ generator: Generator) {
		_scope = try! generator.subscribe { _ in
			print("Do things with data")
		}
	}

	public func dispose() {
		_scope.dispose()
	}

	private var _scope: Scope
}

class Generator : IDisposable
{
	public init() {
		_subscribers = Array<Subscriber>()
	}

	public func dispose() {
		if (_subscribers == nil) {
			return
		}

		for subscriber in _subscribers! {
			_ = subscriber.scope?.transfer()
		}
		_subscribers = nil
	}

	public func subscribe(_ callback: @escaping (Data) -> ()) throws -> Scope {
		if (_subscribers == nil) {
			throw ObjectDisposedException.ObjectDisposed
		}

		let sub = Subscriber(callback)
		let scope = Scope {
			self._subscribers = self._subscribers!.filter { $0 !== sub }
		}
		sub.scope = scope
		_subscribers?.append(sub)
		return scope
	}

	private var _subscribers: Array<Subscriber>?
}

private class Subscriber
{
	public var callback: (Data) -> ()
	public var scope: Scope?

	public init(_ callback: @escaping (Data) -> ()) {
		self.callback = callback
	}
}
```
