//
//  UploudContact.h
//  ZhuaMa
//
//  Created by xll on 15/2/5.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@protocol UploadContactDelegate <NSObject>

-(void)didFinishLoad;
-(void)didFailLoad;
-(void)isNotAllowedAccess;

@end

@interface UploudContact : BaseADView
@property (nonatomic, strong) NSMutableArray *listContacts;
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)id<UploadContactDelegate>delegate;
@property (nonatomic, assign) ABAddressBookRef addressBookRef;
-(void)inits;
- (void)filterContentForSearchText:(NSString*)searchText;
-(void)loadData;
@end
