//
//  WTMainTableViewController.m
//  Wheely_Test
//
//  Created by Irina Didkovskaya on 1/10/14.
//  Copyright (c) 2014 Irina. All rights reserved.
//

#import "WTMainTableViewController.h"
#import "Item.h"
#import "WTCoordinator.h"
#import "WTDetailViewController.h"
#import "WTRoundView.h"
#import "WTMainCell.h"

#define TIME_RELOAD_INTERVAL 15

@interface WTMainTableViewController () <NSFetchedResultsControllerDelegate>
{
    NSTimer *reloadDataTimer;
}
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation WTMainTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    reloadDataTimer = [NSTimer scheduledTimerWithTimeInterval:TIME_RELOAD_INTERVAL target:self selector:@selector(reloadData) userInfo:nil repeats:YES];
    
    UIBarButtonItem *reloadBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadData)];
    self.navigationItem.rightBarButtonItem = reloadBtn;
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error])
    {
        NSLog(@"Error! %@",error);
        abort();
    }
    [self reloadData];
}

- (void)reloadData
{
    [[WTCoordinator sharedCoordinator] updateItems:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    WTMainCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[WTMainCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(WTMainCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.itemText;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    CGRect rectTitle = [item.title boundingRectWithSize:CGSizeMake(self.tableView.frame.size.width-60, 10000) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16]} context:nil];
    
    CGRect rect = [item.itemText boundingRectWithSize:CGSizeMake(self.tableView.frame.size.width-60, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont italicSystemFontOfSize:14]} context:nil];
    
    return rect.size.height + rectTitle.size.height + 50;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = self.storyboard;
    WTDetailViewController *detailViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"pushDetailViewController"];
    detailViewController.item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.tableView deselectRowAtIndexPath:[self.tableView
                                              indexPathForSelectedRow] animated: YES];
}

#pragma mark NSFetchResultController
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController)
	{
        return _fetchedResultsController;
    }
    
    NSManagedObjectContext *moc = [NSManagedObjectContext MR_defaultContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *item = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:moc];
    [fetchRequest setEntity:item];
    
    [fetchRequest setFetchBatchSize:20];
    
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setReturnsObjectsAsFaults:NO];
    
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc]
                                                               
															   initWithFetchRequest:fetchRequest
															   managedObjectContext:moc
															   sectionNameKeyPath:nil
															   cacheName:nil];
    
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

#pragma mark NSfetchResultControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(WTMainCell *)[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
