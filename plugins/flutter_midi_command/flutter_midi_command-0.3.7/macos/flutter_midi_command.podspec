#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_midi_command.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_midi_command'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/InvisibleWrench/FlutterMidiCommand'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Invisible Wrench' => 'hello@invisiblewrench.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.13'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
