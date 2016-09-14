Pod::Spec.new do |s|
  s.name             = "SwiftCompressor"
  s.version          = "0.2.0"
  s.summary          = "Compression framework easily"
  s.description      = "SwiftCompressor lets you use Compression framework easily"
  s.homepage         = "https://github.com/DroidsOnRoids/SwiftCompressor"
  s.license          = 'MIT'
  s.author           = { "Piotr Sochalewski" => "piotr.sochalewski@droidsonroids.com" }
  s.source           = { :git => "https://github.com/DroidsOnRoids/SwiftCompressor.git", :tag => s.version.to_s }
  s.platforms = { :ios => "9.0", :osx => "10.11", :watchos => "2.0", :tvos => "9.0" }
  s.requires_arc = true
  s.source_files = '*.swift'
  # .tbd linking doesn't work well
  # s.library = 'compression'
  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lcompression' }
end
