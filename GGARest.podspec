#
# Be sure to run `pod lib lint GGARest.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GGARest'
  s.version          = '0.0.1'
  s.summary          = 'REST library for iOs applications with automatic JSON serialization / deserialization'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
REST library for iOs applications with automatic JSON serialization / deserialization
See examples in github
                       DESC

  s.homepage         = 'https://greengrowapps.com'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'Apache2', :file => 'LICENSE' }
  s.author           = { 'GreenGrowAppa' => 'info@greengrowapps.com' }
  s.source           = { :git => 'https://github.com/greengrowapps/GGARest-iOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'GGARest/Classes/**/*'
  
  # s.resource_bundles = {
  #   'GGARest' => ['GGARest/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
