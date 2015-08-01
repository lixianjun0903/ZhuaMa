//
//  ContactUpLoad.h
//  ZhuaMa
//
//  Created by xll on 15/1/22.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@protocol UploadContactDelegate <NSObject>

-(void)didFinishLoad;
-(void)didFailLoad;
-(void)isNotAllowedAccess;

@end

@interface ContactUpLoad : NSObject

@property (nonatomic, strong) NSMutableArray *listContacts;
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)id<UploadContactDelegate>delegate;
 @property (nonatomic, assign) ABAddressBookRef addressBookRef;
-(void)inits;
- (void)filterContentForSearchText:(NSString*)searchText;
-(void)loadData;
@end
