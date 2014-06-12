//
//  GDIImageTintingTableViewController.m
//  GravityDemo
//
//  Created by Grant Davis on 6/12/14.
//  Copyright (c) 2014 Grant Davis Interactive, LLC. All rights reserved.
//

#import "GDIImageTintingTableViewController.h"


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
    return 4;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    switch (section) {
        case 0:
            title = @"Colored image with alpha";
            break;
            
        case 1:
            title = @"Colored image without alpha";
            break;
            
        case 2:
            title = @"Grayscale image with alpha";
            break;
            
        case 3:
        default:
            title = @"Grayscale image without alpha";
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
        cell.textLabel.text = @"Tinted";
    }
    
    if (indexPath.row == 1) {
        
        if (indexPath.section == 0) {
            cell.imageView.image = [cell.imageView.image imageWithTintColor:[UIColor colorWithRGBHex:0x00ff00]
                                                              useImageAlpha:YES];
        }
        else if (indexPath.section == 1) {
            cell.imageView.image = [cell.imageView.image imageWithTintColor:[UIColor colorWithRGBHex:0x00ff00]
                                                              useImageAlpha:NO];
        }
        else if (indexPath.section == 2) {
            cell.imageView.image = [cell.imageView.image imageWithTintColor:[UIColor colorWithRGBHex:0x00ff00]
                                                              useImageAlpha:YES];
            
        }
        else if (indexPath.section == 3) {
            cell.imageView.image = [cell.imageView.image imageWithTintColor:[UIColor colorWithRGBHex:0x00ff00]
                                                              useImageAlpha:NO];
        }
    }
    
    return cell;
}


- (UIImage *)imageForIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return [UIImage imageNamed:@"ability-point-frame"];
            
        case 1:
            return [UIImage imageNamed:@"Cassiopeia_Square_0"];
            
        case 2:
            return [UIImage imageNamed:@"ability-point-frame-grayscale"];
            
        case 3:
            return [UIImage imageNamed:@"Cassiopeia_Square_0_greyscale"];
            
        default:
            break;
    }
    return nil;
}


@end
