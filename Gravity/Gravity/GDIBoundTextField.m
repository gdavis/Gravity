//
//  GDIBoundTextField.m
//  Gravity
//
//  Created by Grant Davis on 6/18/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "GDIBoundTextField.h"

@interface GDIBoundTextField () {
    __weak NSObject *_boundObject;
    NSString *_boundKeypath;
}

- (void)removeBind;

@end

@implementation GDIBoundTextField

- (void)bindTextToObject:(NSObject *)obj keyPath:(NSString *)keypath
{
    // remove bind to previous object
    [self removeBind];
    
    // store references
    _boundObject = obj;
    _boundKeypath = [NSString stringWithString:keypath];
    
    // bind to new object
    if (_boundObject) {
        [_boundObject addObserver:self forKeyPath:_boundKeypath options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)dealloc
{
    [self removeBind];
}

- (void)removeBind
{
    if (_boundObject) {
        [_boundObject removeObserver:self forKeyPath:_boundKeypath];
        _boundObject = nil;
        _boundKeypath = nil;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    if ([keyPath isEqualToString:_boundKeypath]) {
        NSString *newText = [change objectForKey:NSKeyValueChangeNewKey];
        self.text = newText;
    }
}

- (BOOL)resignFirstResponder
{
    // attempt to our text value on our bound object
    if (_boundObject && _boundKeypath) {
        [_boundObject setValue:self.text forKey:_boundKeypath];
    }
    return [super resignFirstResponder];
}

@end
