//
//  MusicTableViewController.m
//  SignedInTunes
//
//  Created by Kevin Yu on 12/17/18.
//  Copyright © 2018 Kevin Yu. All rights reserved.
//

#import "MusicTableViewController.h"
#import "SignedInTunes-Swift.h"

@class MusicViewModel;

// class extension
// not to be confused for Swift's extensions
// nameless category
@interface MusicTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) MusicViewModel* viewModel;

@end

@implementation MusicTableViewController

// class property/ class variable
static NSString *cellIdentifier = @"basicCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupViewModel];
}

- (void)setupViewModel {
    self.viewModel = [[MusicViewModel alloc] init];
    [self.viewModel getAlbums:^{
        [self.tableView reloadData];
    }];
}

- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:cellIdentifier];
}

// MARK: - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return self.viewModel.numberOfAlbums;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // customization of cell
    cell.textLabel.text = [self.viewModel titleForAlbum:indexPath.row];
    
    // who does the downloading?
    // VC?
    // this method?
    //
    // cell.imageView.image = self.albums[indexPath.row].albumImage
    cell.textLabel.numberOfLines = 0;
    NSLog(@"Will show cell: %li", (long)indexPath.row);
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}


@end
