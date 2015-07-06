Pod::Spec.new do |s|
  s.name     = 'Gravity'
  s.version  = '1.2.2'
  s.platform = :ios, '7.0'
  s.license  = 'MIT'
  s.summary  = 'A robust set of tools commonly used during iOS development.'
  s.homepage = 'https://github.com/gdavis/Gravity'
  s.author   = { 'Grant Davis' => 'grant@grantdavisinteractive.com' }
  s.source   = { :git => 'https://github.com/gdavis/Gravity.git', :tag => s.version.to_s }

  s.description = 'Gravity is a collection of commonly used categories, components, and helpers to perform a variety of tasks from drawing gradient fills, resizing scroll views for keyboards, generating colors with hex values, and much more.'

  s.source_files = 'Gravity/*.{h,m}'
  s.frameworks   = 'QuartzCore','CoreGraphics'
  s.libraries = 'z'
  s.requires_arc = true
  
  s.subspec 'Color' do |ss|
   ss.dependency 'GDIColor', '~> 0.1'
  end
  
  s.subspec 'CoreData' do |ss|
   ss.dependency 'GDICoreDataKit', '~> 0.1.1'
  end
end
