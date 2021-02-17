Pod::Spec.new do |s|
  s.name             = 'I3DRecorder'
  s.version          = '1.0.0'
  s.summary          = 'in3D iOS SDK for 3D body model creation.'
 
  s.description      = <<-DESC
in3D iOS SDK helps you to record data for 3D body model creation. SDK makes it easy to create your own recording screens.
                       DESC
 
  s.homepage         = 'https://github.com/in3D-io/in3D-iOS-SDK'
  s.author           = { 'loringit' => 'yakupov.bulat@gmail.com' }
  s.source           = { :git => 'https://github.com/in3D-io/in3D-iOS-SDK.git', :tag => s.version.to_s }
  s.vendored_frameworks = 'I3DRecorder.xcframework' 
  s.swift_version = '5'
  s.platform = :ios
  s.ios.deployment_target = '12.0'
end