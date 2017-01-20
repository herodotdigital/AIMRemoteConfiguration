Pod::Spec.new do |s|
  s.name         = "AIMRemoteConfiguration"
  s.version      = "0.2"
  s.summary      = "Remote configuration for your app by http://allinmobile.co"
  s.homepage     = "https://github.com/AllinMobile/AIMRemoteConfiguration"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Maciej Gad" => "https://github.com/MaciejGad" }
  s.social_media_url   = "https://twitter.com/maciej_gad"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/AllinMobile/AIMRemoteConfiguration.git", :tag => 'v0.2' }
  s.source_files  =  "Sources/*.{h,m}"
  s.requires_arc = true
  s.dependency "libextobjc"

end