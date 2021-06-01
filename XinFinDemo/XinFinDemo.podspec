#
#  Be sure to run `pod spec lint XinFinDemo.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "XinFinDemo"
  spec.version      = "0.1.0"
  spec.summary      = "This is the best framework for ever"
  spec.description  = "XinFin Framework is used to get the XinFin XDC Data"

  spec.homepage     = "https://github.com/prashanth2468/XinfinDemo"
  spec.license      = "MIT"
  spec.author       = { "Prashant" => "Prashanth@leewayhertz.com" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/prashanth2468/XinfinDemo.git", :tag => spec.version.to_s }


  spec.source_files  = "XinFinDemo", "XinFinDemo/**/*.{h,m}"
  spec.swift_versions = "5.0"


end
