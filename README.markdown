# Gravity - An iOS Toolkit 
[![Build Status](https://travis-ci.org/gdavis/Gravity.png?branch=master)](https://travis-ci.org/gdavis/Gravity)
[![Pod version](https://cocoapod-badges.herokuapp.com/v/Gravity/badge.png)](https://github.com/gdavis/Gravity)

Authored by [Grant Davis](http://www.grantdavisinteractive.com).

Gravity is a collection of categories, components, and utility methods
brought together into a single library.

It includes additions for view management...

* [UIView+GDIAdditions](https://github.com/gdavis/Gravity/blob/master/Gravity/UIView%2BGDIAdditions.h)
  (custom frame management and debug mode)
* [UIView+GDIAnimation](https://github.com/gdavis/Gravity/blob/master/Gravity/UIView%2BGDIAnimation.h)
  (fadeIn/fadeOut animations)
* [UIColor+GDIAdditions](https://github.com/gdavis/Gravity/blob/master/Gravity/UIColor%2BGDIAdditions.h)
  (color interpolation and custom initializers)

Working with data...

* [NSData+GDIAdditions](https://github.com/gdavis/Gravity/blob/master/Gravity/NSData%2BGDIAdditions.h)
  (with md5 and gzip)
* [NSManagedObject+Clone](https://github.com/gdavis/Gravity/blob/master/Gravity/NSManagedObject%2BClone.h) 
* [NSManagedObject+GDIOrderedSetAccessors](https://github.com/gdavis/Gravity/blob/master/Gravity/NSManagedObject%2BGDIOrderedSetAccessors.h)

And much
[more](https://github.com/gdavis/Gravity/tree/master/Gravity).  


### Using Gravity

Gravity can be easily installed using [Cocoapods](http://cocoapods.org)
by adding the following line to you project's Podfile:

> pod 'Gravity'

To manually install Gravity, follow the Apple Developer Guide for
linking against static libraries here:
https://developer.apple.com/library/ios/technotes/iOSStaticLibraries/Articles/configuration.html#//apple_ref/doc/uid/TP40012554-CH3-SW1

### Status

I'm currently in the process of breaking Gravity out into smaller modules. I've learned over time its not a great idea to have a big "toolbox" repository such as this one. I typically probably use 20-40% of the library, and that is not ideal. 

This project will slowly be phased out in favor of the new pared down, more focused repos. Below are the repos that have already been broken out:

[GDIColor](https://github.com/gdavis/GDIColor)
[GDIImageOperation](https://github.com/gdavis/GDIImageOperation)
[GDICoreDataKit](https://github.com/gdavis/GDICoreDataKit)
