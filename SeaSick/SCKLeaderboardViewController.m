//
//  SCKLeaderboardViewController.m
//  SeaSick
//
//  Created by Asaf Gartner on 27/10/2013.
//
//

#import "SCKLeaderboardViewController.h"
#import "Services/SCKGameServer.h"
#import "Models/SCKSCore.h"

#ifdef DEBUG
#define GAME_SERVER_URL @"localhost:8088"
#else
#define GAME_SERVER_URL @"seasick.herokuapp.com"
#endif

@interface SCKLeaderboardViewController ()

@property (nonatomic, strong) NSArray* scores;

@end

@implementation SCKLeaderboardViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  
  [SCKGameServer requestScores:GAME_SERVER_URL withBlock:^(NSArray *scoresResult) {
    self.scores = scoresResult;
    [self.tableView reloadData];
  }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Score" forIndexPath:indexPath];
  SCKScore *score = (SCKScore *)self.scores[indexPath.item];
  cell.textLabel.text = score.Id;
  cell.detailTextLabel.text = score.score;
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.scores.count;
}

@end
