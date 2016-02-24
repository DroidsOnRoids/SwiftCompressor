Pod::Spec.new do |s|
  s.name             = "SwiftCompressor"
  s.version          = "0.1.0"
  s.summary          = "Compression framework easily"
  s.description      = "SwiftCompressor lets you use Compression framework easily"
  s.homepage         = "https://github.com/sochalewski/SwiftCompression"
  s.license          = 'MIT'
  s.author           = { "Piotr Sochalewski" => "piotr.sochalewski@droidsonroids.com" }
  s.source           = { :git => "https://github.com/DroidsOnRoids/SwiftCompression.git", :tag => s.version.to_s }
  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "10.11"
  s.requires_arc = true
  s.source_files = '*.swift'
  # .tbd linking doesn't work well
  # s.library = 'compression'
  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lcompression' }
end
