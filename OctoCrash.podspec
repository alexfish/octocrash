#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|
  s.name         = "OctoCrash"
  s.version      = "0.1.0"
  s.summary      = "A short description of OctoCrash."
  s.description  = <<-DESC
                    An optional longer description of OctoCrash

                    * Markdown format.
                    * Don't worry about the indent, we strip it!
                   DESC
  s.homepage     = "http://EXAMPLE/NAME"
  s.screenshots  = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license      = 'MIT'
  s.author       = { "Alex Fish" => "alex@alexefish.com" }
  #s.source       = { :git => "http://EXAMPLE/NAME.git", :tag => s.version.to_s }

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Classes'
  s.resources = 'Assets'

  s.dependency   "AFNetworking", "~> 2.0"
  s.dependency   "Mantle", "~> 1.3.1"
  s.vendored_frameworks = 'Vendor/CrashReporter.framework'
end
