Pod::Spec.new do |spec|
  spec.name         = 'AsyncDisplayKit'
  spec.version      = '1.0beta'
  spec.license      =  { :type => 'BSD' }
  spec.homepage     = 'https://github.com/facebook/AsyncDisplayKit'
  spec.authors      = { 'Nadine Salter' => 'nadi@fb.com', 'Scott Goodson' => 'scottg@fb.com' }
  spec.summary      = 'Smooth asynchronous user interfaces for iOS apps.'
  spec.source       = { :git => 'https://github.com/facebook/AsyncDisplayKit.git', :tag => '1.0beta' }

  spec.public_header_files = [
      'AsyncDisplayKit/*.h',
      'AsyncDisplayKit/Details/**/*.h',
      'Base/*.h'
  ]

  spec.source_files = [
      'AsyncDisplayKit/**/*.{h,m,mm}',
      'Base/*.{h,m}'
  ]

  # ASDealloc2MainObject must be compiled with MRR
  spec.requires_arc = true
  spec.exclude_files = ['AsyncDisplayKit/Details/ASDealloc2MainObject.m']
  spec.subspec 'ASDealloc2MainObject' do |mrr|
    mrr.requires_arc = false
    mrr.source_files = [
      'AsyncDisplayKit/Private/_AS-objc-internal.h',
      'AsyncDisplayKit/Details/ASDealloc2MainObject.h',
      'AsyncDisplayKit/Details/ASDealloc2MainObject.m',
    ]
  end

  spec.social_media_url = 'https://twitter.com/fbOpenSource'
  spec.library = 'c++'
  spec.xcconfig = {
       'CLANG_CXX_LANGUAGE_STANDARD' => 'c++11',
       'CLANG_CXX_LIBRARY' => 'libc++'
  }

  spec.ios.deployment_target = '7.0'
end
