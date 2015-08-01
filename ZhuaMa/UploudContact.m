//
//  UploudContact.m
//  ZhuaMa
//
//  Created by xll on 15/2/5.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "UploudContact.h"

@implementation UploudContact
@synthesize addressBookRef;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    self = [super self];
    if (self) {
        [self inits];
    }
    return self;
}


-(void)inits
{
    CFErrorRef error = NULL;
    
    addressBookRef = ABAddressBookCreateWithOptions(NULL, &error);
    
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
        
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getContactsFromAddressBook];
            });
        }
        else
        {
            [_delegate isNotAllowedAccess];
        }
    });
    
    //    if(addressBook)
    //    {
    //        CFRelease(addressBook);
    //    }
    //
}
-(void)getContactsFromAddressBook
{
    self.listContacts = [NSMutableArray arrayWithCapacity:0];
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if (addressBook) {
        NSArray *allContacts = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
        
        NSUInteger i = 0;
        for (i = 0; i<[allContacts count]; i++)
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            // Get first and last names
            NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
            NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            
            NSString *name = [NSString stringWithFormat:@"%@%@",lastName,firstName];
            [dic setObject:name forKey:@"name"];
            
            
            // Get mobile number
            ABMultiValueRef phonesRef = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
            NSString * phone = [self getMobilePhoneProperty:phonesRef];
            if (phone) {
                [dic setObject:phone forKey:@"mobile"];
            }
            else
            {
                [dic setObject:@"" forKey:@"mobile"];
            }
            if(phonesRef) {
                CFRelease(phonesRef);
            }
            [self.listContacts addObject:dic];
        }
        
        if(addressBook) {
            CFRelease(addressBook);
        }
        [self loadData];
    }
    else
    {
        NSLog(@"Error");
        
    }
}
- (NSString *)getMobilePhoneProperty:(ABMultiValueRef)phonesRef
{
    //    for (int i=0; i < ABMultiValueGetCount(phonesRef); i++) {
    CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, 0);
    CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, 0);
    
    if(currentPhoneLabel) {
        if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
            return (__bridge NSString *)currentPhoneValue;
        }
        
        if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
            return (__bridge NSString *)currentPhoneValue;
        }
    }
    if(currentPhoneLabel) {
        CFRelease(currentPhoneLabel);
    }
    if(currentPhoneValue) {
        CFRelease(currentPhoneValue);
    }
    //    }
    
    return nil;
}
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
//    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];

    NSString *jsonstr = [self.listContacts JSONRepresentation];
    

    
    NSString *urlstr = [NSString stringWithFormat:@"%@uploadcontacts?uid=%@&token=%@&contacts=%@",SERVER_URL,uid,token,jsonstr];
    
    self.mDownManager= [[ImageDownManager alloc]init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    [_mDownManager GetImageByStr:urlstr];
    //    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithCapacity:0];
    //    [d setObject:jsonstr forKey:@"contacts"];
    
}
-(void)OnLoadFinish:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]] && dict.count>0) {
        NSLog(@"%@", dict);
        if ([[dict[@"code"] stringValue]isEqualToString:@"1"]) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:@"1" forKey:@"upload"];
            [user synchronize];
            [_delegate didFinishLoad];
        }
        else
        {
            [_delegate didFailLoad];
        }
    }
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [_delegate didFailLoad];
    [self Cancel];
}

- (void)Cancel {
//    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}
-(void)dealloc
{
    _mDownManager.delegate = nil;
}

@end
