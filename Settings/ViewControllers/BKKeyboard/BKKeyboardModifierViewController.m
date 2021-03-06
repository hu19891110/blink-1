////////////////////////////////////////////////////////////////////////////////
//
// B L I N K
//
// Copyright (C) 2016 Blink Mobile Shell Project
//
// This file is part of Blink.
//
// Blink is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Blink is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Blink. If not, see <http://www.gnu.org/licenses/>.
//
// In addition, Blink is also subject to certain additional terms under
// GNU GPL version 3 section 7.
//
// You should have received a copy of these additional terms immediately
// following the terms and conditions of the GNU General Public License
// which accompanied the Blink Source Code. If not, see
// <http://www.github.com/blinksh/blink>.
//
////////////////////////////////////////////////////////////////////////////////

#import "BKKeyboardModifierViewController.h"
#import "BKDefaults.h"

@implementation BKKeyboardModifierViewController
{
  NSArray *_items;
  NSIndexPath *_currentSelectionIdx;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
  if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
    [self performSegueWithIdentifier:@"unwindFromKeyboardModifier" sender:self];
  }
  [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSString *)selectedObject
{
  return _items[_currentSelectionIdx.row];
}

- (void)loadData
{
  _items = [BKDefaults keyboardModifierList];
}

- (void)performInitialSelection:(NSString *)selectedModifier
{
  if (_items == nil || _items.count == 0) {
    [self loadData];
  }
  NSInteger pos;
  if (selectedModifier.length) {
    pos = [_items indexOfObject:selectedModifier];
  } else {
    pos = 0;
  }
  _currentSelectionIdx = [NSIndexPath indexPathForRow:pos inSection:0];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"keyModifierCell" forIndexPath:indexPath];
  cell.textLabel.text = [_items objectAtIndex:indexPath.row];
  if (_currentSelectionIdx == indexPath) {
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
  } else {
    [cell setAccessoryType:UITableViewCellAccessoryNone];
  }
  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (_currentSelectionIdx != nil) {
    // When in selectable mode, do not show details.
    [[tableView cellForRowAtIndexPath:_currentSelectionIdx] setAccessoryType:UITableViewCellAccessoryNone];
  }
  _currentSelectionIdx = indexPath;
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

@end
