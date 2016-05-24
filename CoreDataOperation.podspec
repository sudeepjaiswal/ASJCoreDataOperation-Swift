Pod::Spec.new do |s|
  s.name         = 'CoreDataOperation'
  s.version      = '0.1'
  s.platform	   = :ios, '8.0'
  s.license      = { :type => 'MIT' }
  s.homepage     = 'https://github.com/sudeepjaiswal/CoreDataOperation'
  s.authors      = { 'Sudeep Jaiswal' => 'sudeepjaiswal87@gmail.com' }
  s.summary      = 'Do asynchronous CoreData operations without blocking your UI'
  s.source       = { :git => 'https://github.com/sudeepjaiswal/CoreDataOperation.git', :tag => s.version }
  s.source_files = 'CoreDataOperation/*.swift'
  s.requires_arc = true
end