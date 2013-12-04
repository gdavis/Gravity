Pod::Spec.new do |s|
  s.name     = 'Gravity'
  s.version  = '0.1.0'
  s.platform = :ios
  s.license  = 'MIT'
  s.summary  = 'A robust set of tools commonly used during iOS development.'
  s.homepage = 'http://grantdavisintearctive.com'
  s.author   = { 'Grant Davis' => 'grant@grantdavisinteractive.com' }
  s.source   = { :git => 'https://github.com/gdavis/Gravity.git', :tag => s.version.to_s }

  s.description = 'Gravity is a collection of commonly used categories, components, and helper objects to perform a variety of tasks from drawing gradient fills, resizing scroll views for keyboards, generating colors with hex values, and much more.'

  s.source_files = 'Gravity/*.{h,m}'
  s.framework    = 'QuartzCore'
  s.resources    = ''
  s.requires_arc = true
end