Pod::Spec.new do |spec|
  spec.name          = "BetterSheet"
  spec.version       = "1.0.0"
  spec.author        = { "Peter Verhage" => "peter@egeniq.com" }
  spec.homepage      = "https://github.com/egeniq/BetterSheet"
  spec.license       = { :type => "MIT", :file => "LICENSE" }
  spec.summary       = "A powerful SwiftUI sheet replacement."
  spec.description   = <<-DESC
    A powerful SwiftUI sheet replacement which is more robust and offers
    support for modal sheets that can't simply be swiped to dismiss.
  DESC

  spec.swift_version         = '5.1'
  spec.ios.deployment_target = '13.0'
  
  spec.source        = { :git => "https://github.com/egeniq/BetterSheet.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources", "Sources/**/*.swift"
end
