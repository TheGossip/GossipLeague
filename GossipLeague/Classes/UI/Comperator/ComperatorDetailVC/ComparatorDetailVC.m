//
//  ComparatorDetailVC.m
//  GossipLeague
//
//  Created by Valenti on 23/04/13.
//  Copyright (c) 2013 Gossip. All rights reserved.
//

#import "ComparatorDetailVC.h"
#import "PlayerEntity.h"
#import "GameEntity.h"
#import "GameCell.h"
#import "ComparatorInfoDetailCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComparatorGamesVC.h"

static NSString * const CellGameIdentifier = @"CellGameIdentifier";
static NSString * const CellInformationIdentifier = @"ComparatorInfoDetailCell";

@interface ComparatorDetailVC ()

//Entities
@property (nonatomic,strong) PlayerEntity *player1;
@property (nonatomic,strong) PlayerEntity *player2;

@property (strong, nonatomic) IBOutlet UIView *comparatorFields;
@property (nonatomic,strong) IBOutlet UIImageView *profilePlayer1;
@property (nonatomic,strong) IBOutlet UIImageView *profilePlayer2;
@property (weak, nonatomic) IBOutlet UILabel *namePlayer1;
@property (weak, nonatomic) IBOutlet UILabel *namePlayer2;

@property (weak, nonatomic) IBOutlet UITableView *informationsTableView;

@property (strong, nonatomic) NSArray *games;

@end

@implementation ComparatorDetailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil player1:(PlayerEntity*)player1 player2:(PlayerEntity*)player2
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.player1 = player1;
        self.player2 = player2;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"VS";
    
    [self setupUIBar];
    [self setupHeader];
    [self setupInformationsTable];
}

- (void)setupUIBar
{
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Games" style:UIBarButtonItemStyleBordered target:self action:@selector(goToGames)];
    [self.navigationItem setRightBarButtonItem:barButton];
}

- (void)goToGames
{
    ComparatorGamesVC *comparatorGamesVC = [[ComparatorGamesVC alloc] initWithPlayer:self.player1 andPlayer:self.player2];
    [self.navigationController pushViewController:comparatorGamesVC animated:YES];
}

- (void)setupHeader
{
    self.namePlayer1.font = [UIFont fontForUsernameInCell];
    self.namePlayer1.textColor = [UIColor colorTableCellLabel];
    self.namePlayer2.font = [UIFont fontForUsernameInCell];
    self.namePlayer2.textColor = [UIColor colorTableCellLabel];
    self.namePlayer1.text = self.player1.username;
    self.namePlayer2.text = self.player2.username;
    [self.profilePlayer1 setImageWithURL:[NSURL URLWithString:self.player1.avatarURL]];
    [self.profilePlayer2 setImageWithURL:[NSURL URLWithString:self.player2.avatarURL]];
}

- (void)setupInformationsTable
{
    self.informationsTableView.rowHeight = 50;
    [self.informationsTableView registerNib:[UINib nibWithNibName:@"ComparatorInfoDetailCell" bundle:nil]
              forCellReuseIdentifier:CellInformationIdentifier];
    self.informationsTableView.tableHeaderView = self.comparatorFields;
    self.informationsTableView.backgroundColor = [UIColor colorBackgroundTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *descriptions = @[
                              @"Games",
                              @"Wins",
                              @"Draws",
                              @"Losses",
                              @"Goals Ratio"];
    
    NSArray *player1Values = @[
                               @(self.player1.games),
                               [NSString stringWithFormat:@"%.0f%%", self.player1.winGamesPor100],
                               [NSString stringWithFormat:@"%.0f%%", self.player1.drawGamesPor100],
                               [NSString stringWithFormat:@"%.0f%%", self.player1.lostGamesPor100],
                               [NSString stringWithFormat:@"%.2f", self.player1.goalsRatio]
                               ];
    
    NSArray *player2Values = @[
                               @(self.player2.games),
                               [NSString stringWithFormat:@"%.0f%%", self.player2.winGamesPor100],
                               [NSString stringWithFormat:@"%.0f%%", self.player2.drawGamesPor100],
                               [NSString stringWithFormat:@"%.0f%%", self.player2.lostGamesPor100],
                               [NSString stringWithFormat:@"%.2f", self.player2.goalsRatio]
                               ];
    
    ComparatorInfoDetailCell *infoCell = [tableView dequeueReusableCellWithIdentifier:CellInformationIdentifier];
    
    infoCell.player1Value.text = [[player1Values objectAtIndex:indexPath.row] description];
    infoCell.player2Value.text = [[player2Values objectAtIndex:indexPath.row] description];
    infoCell.description.text = [descriptions objectAtIndex:indexPath.row];
    
    return infoCell;
}

- (void)viewDidUnload
{
    [self setNamePlayer1:nil];
    [self setNamePlayer2:nil];
    [self setInformationsTableView:nil];
    [self setComparatorFields:nil];
    [super viewDidUnload];
}

@end
