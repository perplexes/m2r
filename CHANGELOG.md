# Changelog

## 2.1.0

* Retry response delivery when interrupt signal received. Mark connection errors coming from signals.
* Introduce handler event for interrupt signal.
* Graceful stop for Rack handler.
* Extract request parser from request.
* Introduce MultithreadedHandler to dispatch requests in multiple threads.
* Update ffi-rzmq dependency.
* Remove circular require invocations.

## 2.0.2

* Fixed #55 : Rack response body is closed.
