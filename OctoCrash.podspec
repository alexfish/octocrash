#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|
  s.name          = "OctoCrash"
  s.version       = "0.1.0"
  s.summary       = "A Github issue crash reporter"
  s.description   = <<-DESC
                      Send crashes to Github as a issues for simple and
                      lightweight crash reporting
                   DESC
  s.homepage      = "https://github.com/alexfish/octocrash"
  s.license       = 'MIT'
  s.author        = { "Alex Fish" => "alex@alexefish.com" }
  s.source        = { :git => "git@github.com:alexfish/octocrash.git", :tag => s.version.to_s }

  s.platform      = :ios, '6.0'
  s.requires_arc  = true

  s.source_files  = 'Classes'
  s.resources     = 'Resources'
  s.dependency    'SSKeychain', '~> 1.2.1'
  s.dependency    'ReactiveCocoa', '>= 2.2.2'
  s.dependency    'OctoKit', '~> 0.5'

  s.frameworks = 'SystemConfiguration', 'MobileCoreServices'
  s.vendored_frameworks = 'Vendor/CrashReporter.framework'
end
