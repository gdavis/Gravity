//
//  GDIImageTintingTableViewController.m
//  GravityDemo
//
//  Created by Grant Davis on 6/12/14.
//  Copyright (c) 2014 Grant Davis Interactive, LLC. All rights reserved.
//

#import "GDIImageTintingTableViewController.h"
#import <GDIColor/UIColor+GDIAdditions.h>


static NSString * const ImageCellReuseIdentifier = @"imageTintCell";


@interface GDIImageTintingTableViewController ()

@end


@implementation GDIImageTintingTableViewController


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 0, 300, 30);
    label.font = [UIFont boldSystemFontOfSize:10];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.numberOfLines = 0;
    label.minimumScaleFactor = 0.2f;
    label.adjustsFontSizeToFitWidth = YES;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)];
    [headerView addSubview:label];
    headerView.backgroundColor = [UIColor whiteColor];
    
    label.center = CGPointMake(CGRectGetMidX(headerView.bounds), CGRectGetMidY(headerView.bounds));
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.f;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    switch (section) {
        case 0:
            title = @"imageWithColor:";
            break;
            
        case 1:
            title = @"imageWithColor:useImageAlpha:(NO)";
            break;
            
        case 2:
            title = @"imageWithColor:blendMode:(multiply)useImageAlpha:(YES)";
            break;
            
        case 3:
            title = @"imageWithColor:blendMode:(multiply)useImageAlpha:(NO)";
            break;
            
        case 4:
            title = @"imageWithColor(50% green):blendMode:(multiply)useImageAlpha:(NO)";
            break;
            
        case 5:
            title = @"imageWithColor(green):blendMode:(multiply)useImageAlpha:(YES)";
            break;
            
        default:
            title = @"[No title set]";
            break;
    }
    
    return title;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ImageCellReuseIdentifier forIndexPath:indexPath];
    cell.imageView.image = [self imageForIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Original";
    }
    else {
        cell.textLabel.text = @"Modified";
    }
    
    if (indexPath.row == 1) {
        
        if (indexPath.section == 0) {
            cell.imageView.image = [cell.imageView.image imageWithColor:[UIColor colorWithRGBHex:0x00ff00]];
        }
        else if (indexPath.section == 1) {
            cell.imageView.image = [cell.imageView.image imageWithColor:[UIColor colorWithRGBHex:0x00ff00]
                                                          useImageAlpha:NO];
        }
        else if (indexPath.section == 2) {
            cell.imageView.image = [cell.imageView.image imageWithColor:[UIColor colorWithRGBHex:0x00ff00]
                                                              useImageAlpha:YES];
            
        }
        else if (indexPath.section == 3) {
            cell.imageView.image = [cell.imageView.image imageWithColor:[UIColor colorWithRGBHex:0x00ff00]
                                                              blendMode:kCGBlendModeMultiply
                                                              useImageAlpha:NO];
        }
        else if (indexPath.section == 4) {
            cell.imageView.image = [cell.imageView.image imageWithColor:[UIColor colorWithRGBHex:0x000000 alpha:0.5f]
                                                              blendMode:kCGBlendModeMultiply
                                                          useImageAlpha:NO];
        }
        else if (indexPath.section == 5) {
            cell.imageView.image = [cell.imageView.image imageWithColor:[UIColor colorWithRGBHex:0x00ff00]
                                                              blendMode:kCGBlendModeMultiply
                                                          useImageAlpha:YES];
        }
    }
    
    return cell;
}


- (UIImage *)imageForIndexPath:(NSIndexPath *)indexPath
{
//    return [UIImage imageNamed:@"quintessence_of_transmutation"];
    switch (indexPath.section) {
        case 0:
        case 1:
        case 5:
            return [UIImage imageNamed:@"quintessence_of_transmutation"];
            
            
        case 2:
        case 3:
            return [UIImage imageNamed:@"quintessence_of_transmutation-grayscale.png"];
            
//        case 3:
//            return [UIImage imageNamed:@"Cassiopeia_Square_0_greyscale"];
            
        case 4:
            return [UIImage imageNamed:@"item-set-items-btn"];
            
        default:
            break;
    }
    return nil;
}


@end
