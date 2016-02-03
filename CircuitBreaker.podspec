#
# Be sure to run `pod lib lint CircuitBreaker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = "CircuitBreaker"
s.version          = "0.1.0"
s.summary          = "A circuit breaker implementation"
s.description      = "Desc: #{s.summary}"

s.homepage         = "https://github.com/pseudomuto/CircuitBreaker"
s.license          = 'MIT'
s.author           = { "pseudomuto" => "david.muto@gmail.com" }
s.source           = { :git => "https://github.com/pseudomuto/CircuitBreaker.git", :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/pseudomuto'

s.platform     = :ios, '8.0'
s.requires_arc = true

s.source_files = 'Pod/Classes/**/*'
s.resource_bundles = {
'CircuitBreaker' => ['Pod/Assets/*.png']
}
end
