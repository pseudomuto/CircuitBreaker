//
//  Invoker.swift
//  Pods
//
//  Created by David Muto on 2016-02-05.
//
//

class Invoker {
  private let queue: dispatch_queue_t!
  
  init(_ queue: dispatch_queue_t) {
    self.queue = queue
  }
  
  func invoke<T>(state: State, timeout: NSTimeInterval, block: () throws -> T) throws -> T {
    var endResult: T?     = nil
    var error: ErrorType? = nil
    
    exec(timeout.dispatchTime(), block: block) { (result, exc) in
      error     = exc
      endResult = result
    }

    if error != nil {
      state.onError()
      throw error!
    }

    state.onSuccess()
    return endResult!
  }
  
  private func exec<T>(timeout: dispatch_time_t, block: () throws -> T, handler: (T?, ErrorType?) -> Void) {
    let semaphore = dispatch_semaphore_create(0)
    
    var result: T? = nil
    var handled = false
    
    let handleError = { (error: ErrorType) in
      if handled { return }

      handled = true
      handler(nil, error)
    }
    
    dispatch_async(queue) {
      defer { dispatch_semaphore_signal(semaphore) }

      do {
        result = try block()
      }
      catch let err {
        handleError(err)
      }
    }

    if dispatch_semaphore_wait(semaphore, timeout) != 0 {
      handleError(Error.InvocationTimeout)
    }
    
    if !handled {
      handler(result, nil)
    }
  }
}
