#
# Be sure to run `pod lib lint ATAlert.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name                    = 'ATAlert'
    s.version                 = '0.1.1'
    s.summary                 = 'Alert view'
    s.homepage                = 'https://github.com/ablettchen/ATAlert'
    s.license                 = { :type => 'MIT', :file => 'LICENSE' }
    s.author                  = { 'ablett' => 'ablettchen@gmail.com' }
    s.source                  = { :git => 'https://github.com/ablettchen/ATAlert.git', :tag => s.version.to_s }
    s.social_media_url        = 'https://twitter.com/ablettchen'
    s.ios.deployment_target   = '8.0'
    s.source_files            = 'ATAlert/**/*.{h,m}'
    s.requires_arc            = true
    
    s.dependency 'ATCategories'
    s.dependency 'Masonry'
    s.dependency 'YYText'
    
end
