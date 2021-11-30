Pod::Spec.new do |spec|

  spec.name         = "VisionGestureKit"
  spec.version      = "0.1.0"
  spec.summary      = "Еhe library allows you to detect and respond to gestures"

  spec.homepage     = "https://github.com/Smart-Dragon/VisionGestureKit"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Smart-Dragon" => "developer.masloboev@yandex.ru" }

  spec.ios.deployment_target = "14.0"
  spec.swift_version = "5.2"

  spec.source        = { :git => "https://github.com/Smart-Dragon/VisionGestureKit.git", :tag => "#{spec.version}" }
  spec.source_files  = "Source/**/*.{h,m,swift}"

  spec.framework     = "UIKit"
  spec.framework     = "Vision"

end
