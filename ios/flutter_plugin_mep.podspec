#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_plugin_mep.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_plugin_mep'
  s.version          = '9.11.4'
  s.summary          = 'flutter plugin for moxo sdk'
  s.description      = <<-DESC
  flutter plugin for moxo sdk
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Moxo' => 'john.hu@moxo.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/*'
  s.public_header_files = 'Classes/*.h'
  s.swift_version = '5.0'
  s.dependency 'Flutter'
  s.dependency 'MEPSDKDylib', '~> 9.11.4'
  s.static_framework = true
  s.platform = :ios, '13.0'
  s.libraries = "c++", "xml2.2","z"
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'OTHER_LDFLAGS' => '-ObjC' }
end
