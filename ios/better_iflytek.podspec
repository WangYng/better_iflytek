#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint better_iflytek.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'better_iflytek'
  s.version          = '0.0.1'
  s.summary          = '科大迅飞SDK'
  s.description      = <<-DESC
科大迅飞SDK
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }

  s.vendored_frameworks = 'iflyMSC.framework'
  s.frameworks = 'AVFoundation', 'SystemConfiguration', 'CoreTelephony'
  s.libraries = 'c++', 'z'
  
end
