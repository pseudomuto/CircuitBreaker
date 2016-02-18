//
//  CircuitBreaker.swift
//  CircuitBreaker
//
//  Created by David Muto on 2016-02-17.
//
//

public enum StateType {
  case Closed
  case Open
  case HalfOpen
}

public enum Error: ErrorType {
  case OpenCircuit
  case InvocationTimeout
}

public class CircuitBreaker {
  private struct Constants {
    static let waitTimeout: NSTimeInterval = 0.1
  }

  private let semaphore = dispatch_semaphore_create(1)

  private let options: Options!
  private let invoker: Invoker!

  // MARK: - States

  private var currentState: State!

  private lazy var closedState: State = {
    ClosedState(
      self,
      invoker: self.invoker,
      errorThreshold: self.options.errorThreshold,
      invocationTimeout: self.options.invocationTimeout
    )
  }()

  private lazy var openState: State = {
    OpenState(self, invoker: self.invoker, resetTimeout: self.options.resetTimeout)
  }()

  private lazy var halfOpenState: State = {
    HalfOpenState(
      self,
      invoker: self.invoker,
      successThreshold: self.options.successThreshold,
      invocationTimeout: self.options.invocationTimeout
    )
  }()

  public var isClosed: Bool { return currentState.type() == .Closed }
  public var isHalfOpen: Bool { return currentState.type() == .HalfOpen }
  public var isOpen: Bool { return currentState.type() == .Open }

  // MARK: - Initializers

  public init(_ name: String, withOptions options: Options) {
    self.invoker = Invoker(dispatch_queue_create(name, DISPATCH_QUEUE_SERIAL))
    self.options = options

    currentState = closedState
  }

  public convenience init(_ name: String) {
    self.init(name, withOptions: Options())
  }

  // MARK: - Invocation

  public func invoke<T>(block: () throws -> T) throws -> T {
    return try currentState.invoke(block)
  }

  // MARK: - State Transitions

  public func force(state: StateType) {
    switch state {
    case .Closed:
      reset(currentState)
    case .Open:
      trip(currentState)
    case .HalfOpen:
      attempt(currentState)
    }
  }

  private func transition(fromState: State, toState: State) {
    // TODO: add logging here
    dispatch_semaphore_wait(semaphore, Constants.waitTimeout.dispatchTime())
    defer { dispatch_semaphore_signal(semaphore) }

    currentState = toState
    currentState.activate()
  }
}

// MARK: - Switch

extension CircuitBreaker: Switch {
  public func reset(fromState: State) {
    transition(currentState, toState: closedState)
  }

  public func trip(fromState: State) {
    transition(currentState, toState: openState)
  }

  public func attempt(fromState: State) {
    transition(currentState, toState: halfOpenState)
  }
}

