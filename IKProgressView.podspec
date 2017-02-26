Pod::Spec.new do |s|
  s.name             = 'IKProgressView'
  s.version          = '0.9'
  s.summary          = 'Neat rainbow radial progress view'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Awesome radial progress view using animated rainbow. Created using CoreGraphics
                       DESC

  s.homepage         = 'https://github.com/igorkislyuk/ikprogressview'
  s.screenshots     = "https://raw.githubusercontent.com/igorkislyuk/ikprogressview/master/gifs/example-1.gif"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'igorkislyuk' => 'igorkislyuk@icloud.com' }
  s.source           = { :git => 'https://github.com/igorkislyuk/ikprogressview.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/igorkislyuk'

  s.ios.deployment_target = '8.0'

  s.source_files = 'IKProgressView/Classes/**/*'
  s.frameworks = 'UIKit', 'QuartzCore'
end
