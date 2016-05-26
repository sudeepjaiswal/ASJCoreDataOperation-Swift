Pod::Spec.new do |s|
  s.name          = 'ASJCoreDataOperation-Swift'
  s.version       = '0.2'
  s.platform      = :ios, '8.0'
  s.license       = { :type => 'MIT' }
  s.homepage      = 'https://github.com/sudeepjaiswal/ASJCoreDataOperation-Swift'
  s.authors       = { 'Sudeep Jaiswal' => 'sudeepjaiswal87@gmail.com' }
  s.summary       = 'Do asynchronous CoreData operations without blocking your UI'
  s.source        = { :git => 'https://github.com/sudeepjaiswal/ASJCoreDataOperation-Swift.git', :tag => s.version }
  s.source_files  = 'ASJCoreDataOperation-Swift/*.swift'
  s.requires_arc  = true
end