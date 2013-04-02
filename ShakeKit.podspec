#
# Be sure to run `pod spec lint ShakeKit.podspec' to ensure this is a
# valid spec.
#
# Remove all comments before submitting the spec. Optional attributes are commented.
#
# For details see: https://github.com/CocoaPods/CocoaPods/wiki/The-podspec-format
#
Pod::Spec.new do |s|
  s.name         = "ShakeKit"
  s.version      = "0.0.4"
  s.summary      = "A short description of ShakeKit."
  s.homepage     = "http://github.com/jeffremer/ShakeKit"

  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author       = { "Jeff Remer" => "jeff@threestarchina.com" }
  s.source       = { :git => "http://github.com/jeffremer/ShakeKit.git", :tag => "0.0.4" }
  s.platform     = :ios, '6.0'
  s.source_files = 'ShakeKit', 'ShakeKit/**/*.{h,m}', 'External', 'External/**/*.{h,m}'
  s.requires_arc = true

  s.dependency 'AFNetworking', '~> 1.1.0'
  s.dependency 'CocoaLumberjack', :head
end
