## Gravity
Authored by [Grant Davis](http://www.grantdavisinteractive.com).

======================

Gravity is a collection of categories, components, and utility methods
brought together into a single library.

It includes additions for view management...

* [UIView+GDIAdditions](https://github.com/atomos86/Gravity/blob/master/Gravity/UIView%2BGDIAdditions.h)
  (custom frame management and debug mode)
* [UIView+GDIAnimation](https://github.com/atomos86/Gravity/blob/master/Gravity/UIView%2BGDIAnimation.h)
  (fadeIn/fadeOut animations)
* [UIColor+GDIAdditions](https://github.com/atomos86/Gravity/blob/master/Gravity/UIColor%2BGDIAdditions.h)
  (color interpolation and custom initializers)

Working with data...

* [NSData+GDIAdditions](https://github.com/atomos86/Gravity/blob/master/Gravity/NSData%2BGDIAdditions.h)
  (with md5 and gzip)
* [NSManagedObject+Clone](https://github.com/atomos86/Gravity/blob/master/Gravity/NSManagedObject%2BClone.h) 
* [NSManagedObject+GDIOrderedSetAccessors](https://github.com/atomos86/Gravity/blob/master/Gravity/NSManagedObject%2BGDIOrderedSetAccessors.h)

And much
[more](https://github.com/atomos86/Gravity/tree/master/Gravity).  


### Using Gravity

Gravity can be easily installed using [Cocoapods](http://cocoapods.org)
by adding the following line to you project's Podfile:

> pod 'Gravity', '~> 1.0.1'

To manually install Gravity, follow the Apple Developer Guide for
linking against static libraries here:
https://developer.apple.com/library/ios/technotes/iOSStaticLibraries/Articles/configuration.html#//apple_ref/doc/uid/TP40012554-CH3-SW1
