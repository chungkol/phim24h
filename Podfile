# Uncomment this line to define a global platform for your project
platform :ios, '9.0'

target 'Phim24h' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
pod 'Firebase'
pod 'Firebase/Database'
pod 'Firebase/Auth'

pod 'Firebase/Core'
pod 'Firebase/AdMob'

pod 'GoogleSignIn'

pod 'FacebookCore'
pod 'FacebookLogin'
pod 'FacebookShare'

pod 'Alamofire'
pod 'JASON'
pod 'Kingfisher'

pod 'MobilePlayer'
pod 'HCSStarRatingView'

pod "OEANotification"

pod 'HTPullToRefresh'

pod 'GRDB.swift'


end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
