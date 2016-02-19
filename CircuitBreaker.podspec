Pod::Spec.new do |s|
  s.name     = "CircuitBreaker"
  s.version  = "0.1.0"
  s.summary  = "A circuit breaker implementation in Swift"
  s.homepage = "https://github.com/pseudomuto/CircuitBreaker"
  s.license  = "MIT"
  s.author   = { "pseudomuto" => "david.muto@gmail.com" }

  s.source       = { git: "https://github.com/pseudomuto/CircuitBreaker.git", tag: s.version.to_s }
  s.source_files = "Pod/Classes/**/*"

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"

  s.requires_arc = true
end
