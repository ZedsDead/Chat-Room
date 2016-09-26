
//  CRChatViewController.m
//  Chat Room
//
//  Created by Anatoli Tauhen on 20.09.16.
//  Copyright © 2016 Ottonova. All rights reserved.
//

#import "CRChatViewController.h"
#import "CRMapViewController.h"
#import "CRGrowingTextView.h"
#import "CRDialogCell.h"
#import "CRWidgetMapCell.h"
#import "CRDialogObject.h"
#import "CRCommand.h"
#import "NSObject+GFJson.h"
#import "NSDate+Utils.h"


static NSString *const kCRMapSegueIdentifier = @"CRMapSegueIdentifier";
static NSString *const kCRMessagePlaceholderText = @"Type a message...";

static const CGFloat kCRGrowingTextViewMaxHeight = 100.0f;


@interface CRChatViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, CRDialogCellDelegate, CRWidgetMapCellDelegate, CRMapViewControllerDelegate, CRGrowingTextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *dialogTableView;
@property (weak, nonatomic) IBOutlet UIView *messagePlaceholder;
@property (weak, nonatomic) IBOutlet CRGrowingTextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *messageTextViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *messagePlaceholderBottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *reachabilityHeightConstraint;

@property (strong, nonatomic) SocketIOClient *socketIO;

@property (strong, nonatomic) NSMutableArray *tableData;

@end


@implementation CRChatViewController

#pragma mark - View lifecicle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUserInterface];
    
    NSURL *url = [NSURL URLWithString:@"http://demo-chat.ottonova.de/"];
    
    self.socketIO = [[SocketIOClient alloc] initWithSocketURL:url config:nil];
    
    __weak typeof(self) welf = self;
    
    [self.socketIO on:@"connect" callback:^(NSArray *data, SocketAckEmitter *ack) {
        NSLog(@"socket connected");
        [welf updateWithReachability:YES];
    }];
    
    [self.socketIO on:@"message" callback:^(NSArray *data, SocketAckEmitter *ack) {
        [welf handleDialogObjects:data];
    }];
    
    [self.socketIO on:@"command" callback:^(NSArray *data, SocketAckEmitter *ack) {
        [welf handleDialogObjects:data];
    }];
    
    [self.socketIO on:@"error" callback:^(NSArray *data, SocketAckEmitter *ack) {
        NSLog(@"Error: %@", data);
        [welf updateWithReachability:(welf.socketIO.status == SocketIOClientStatusConnected)];
    }];
    
    [self.socketIO connect];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardhNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kCRMapSegueIdentifier]) {
        CRMapViewController *mapViewController = segue.destinationViewController;
        mapViewController.delegate = self;
        mapViewController.dialogObject = ((CRWidgetMapCell *)sender).dialogObject;
    }
}

#pragma mark - Private section

- (void)setupUserInterface {
    [self updateWithReachability:NO];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureTapped:)];
    [self.dialogTableView addGestureRecognizer:tapGesture];
    
    self.messageTextView.maxHeight = kCRGrowingTextViewMaxHeight;
    self.messageTextView.text = @"";
    self.messageTextView.delegate = self;
    self.messageTextView.placeholder = kCRMessagePlaceholderText;
    self.messageTextView.placeholderColor = [UIColor lightGrayColor];
    [self.messageTextView setNeedsDisplay];
    
    self.sendButton.enabled = NO;
    
    NSString *commandTitle = @"Command";
    CGSize size = [commandTitle sizeWithAttributes:@{NSFontAttributeName: self.sendButton.titleLabel.font}];
    
    UIButton *commandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commandButton.frame = (CGRect){.origin = CGPointZero, .size = CGSizeMake(size.width, 44.0f)};
    [commandButton setTitle:@"Command" forState:UIControlStateNormal];
    commandButton.titleLabel.font = self.sendButton.titleLabel.font;
    commandButton.titleLabel.textColor = self.sendButton.titleLabel.textColor;
    [commandButton addTarget:self action:@selector(commandButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:commandButton];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)updateWithReachability:(BOOL)reachable {
    self.navigationItem.rightBarButtonItem.enabled = reachable;
    [self updateSendButtonState];
    
    self.reachabilityHeightConstraint.constant = reachable ? 0.0f : 26.0f;
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)updateSendButtonState {
    self.sendButton.enabled = self.socketIO.status == SocketIOClientStatusConnected && self.messageTextView.text.length > 0;
}

- (void)handleDialogObjects:(NSArray *)dialogObjects {
    NSMutableArray *indexPathsToAdd = [NSMutableArray arrayWithCapacity:dialogObjects.count];
    
    for (id objectInfo in dialogObjects) {
        CRDialogObject *object = nil;
        
        if ([objectInfo isKindOfClass:[CRDialogObject class]]) {
            object = objectInfo;
        } else {
            object = [[CRDialogObject alloc] initWithJsonObject:objectInfo];
        }
        
        if (object.command) {
            object.command.data = objectInfo[@"command"][@"data"];
            
            CRDialogObject *message = [object testMessage];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.tableData.count inSection:0];
            [indexPathsToAdd addObject:indexPath];
            [self.tableData addObject:message];

        }
        
        if (object) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.tableData.count inSection:0];
            [indexPathsToAdd addObject:indexPath];
            [self.tableData addObject:object];
        }
    }
    
    [self.dialogTableView beginUpdates];
    [self.dialogTableView insertRowsAtIndexPaths:indexPathsToAdd withRowAnimation:UITableViewRowAnimationFade];
    [self.dialogTableView endUpdates];
    
    [self.dialogTableView scrollToRowAtIndexPath:[indexPathsToAdd firstObject]
                                atScrollPosition:UITableViewScrollPositionTop
                                        animated:YES];
}

- (void)updateDataWithObjects:(NSArray *)objects {
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:objects.count];
    
    for (NSUInteger index = 0; index < objects.count; index++) {
        CRDialogObject *object = objects[index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.tableData indexOfObject:object] inSection:0];
        [indexPaths addObject:indexPath];
    }
    
    [self.dialogTableView beginUpdates];
    [self.dialogTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.dialogTableView endUpdates];
}

- (void)answerCommandWithObject:(CRDialogObject *)object data:(id)data {
    if (self.socketIO.status != SocketIOClientStatusConnected) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Please check your internet connection and try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    object.author = self.nickname;
    object.command.data = data;
    
    [self.socketIO emit:@"command" with:@[[object objectToSend]]];
    
    object.command.complete = @YES;
    
    NSString *message = nil;
    
    if ([object.command.type isEqualToString:kCRCommandTypeDate]) {
        message = [[NSDate dateWithServerString:data] dayOfWeek];
    } else if ([object.command.type isEqualToString:kCRCommandTypeComplete]) {
        message = [data firstObject];
    }
    
    object.message = message;
    
    NSMutableArray *objectsForUpdate = [NSMutableArray arrayWithObject:object];
    
    if ([self.tableData indexOfObject:object] > 0) {
        [objectsForUpdate addObject:self.tableData[[self.tableData indexOfObject:object] - 1]];
    }
    
    [self updateDataWithObjects:objectsForUpdate];
}

- (NSString *)cellIdentifierForDialogObject:(CRDialogObject *)object {
    NSString *identifier = @"";
    
    if (object.command) {
        if (object.command.complete.boolValue) {
            if ([object.command.type isEqualToString:kCRCommandTypeDate] ||
                [object.command.type isEqualToString:kCRCommandTypeComplete]) {
                identifier = @"CROutputMessageCellIdentifier";
            } else if ([object.command.type isEqualToString:kCRCommandTypeMap]) {
                identifier = @"CRReplyMapWidgetCellIdentifier";
            } else if ([object.command.type isEqualToString:kCRCommandTypeRate]) {
                identifier = @"CRReplyRateWidgetCellIdentifier";
            }
        } else {
            if ([object.command.type isEqualToString:kCRCommandTypeDate]) {
                identifier = @"CRWidgetDateCellIdentifier";
            } else if ([object.command.type isEqualToString:kCRCommandTypeMap]) {
                identifier = @"CRWidgetMapCellIdentifier";
            } else if ([object.command.type isEqualToString:kCRCommandTypeRate]) {
                identifier = @"CRWidgetRateCellIdentifier";
            } else if ([object.command.type isEqualToString:kCRCommandTypeComplete]) {
                identifier = @"CRWidgetCompleteCellIdentifier";
            }
        }
    } else if (object.message) {
        if ([object.author isEqualToString:self.nickname]) {
            identifier = @"CROutputMessageCellIdentifier";
        } else {
            identifier = @"CRInputMessageCellIdentifier";
        }
    }
    
    return identifier;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRDialogObject *object = self.tableData[indexPath.row];
    NSString *identifier = [self cellIdentifierForDialogObject:object];
    
    CRDialogCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell configureWithDialogObject:object delegate:self];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRDialogObject *object = self.tableData[indexPath.row];
    NSString *identifier = [self cellIdentifierForDialogObject:object];
    
    CRDialogCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    return [cell cellHeightForDialogObject:object];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    [self updateSendButtonState];
}

- (void)textView:(CRGrowingTextView *)textView didChangeFrame:(CGRect)newFrame {
    self.messageTextViewHeightConstraint.constant = MIN(newFrame.size.height, kCRGrowingTextViewMaxHeight);
    
    [UIView animateWithDuration:0.2f animations:^{
        [self.view layoutIfNeeded];
    }];
    
    NSInteger count = self.tableData.count;
    
    if (count > 0) {
        [self.dialogTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(count - 1) inSection:0]
                                    atScrollPosition:UITableViewScrollPositionBottom
                                            animated:YES];
    }
}

#pragma mark - CRDialogCellDelegate

- (void)dialogCell:(CRDialogCell *)cell didUpdateWithData:(id)data {
    CRDialogObject *object = cell.dialogObject;
    [self answerCommandWithObject:object data:data];
}

- (void)dialogCellReceivedWrongData:(CRDialogCell *)cell {
    CRDialogObject *object = cell.dialogObject;
    object.message = @"Ups, accidentally I sent a wrong command...";
    object.command = nil;
    
    [self updateDataWithObjects:@[object]];
}

#pragma mark - CRWidgetMapCellDelegate

- (void)widgetMapCellDidTouched:(CRWidgetMapCell *)cell {
    [self performSegueWithIdentifier:kCRMapSegueIdentifier sender:cell];
}

#pragma mark - CRMapViewControllerDelegate

- (void)mapViewController:(CRMapViewController *)viewController didUpdateCoordinate:(CLLocationCoordinate2D)coordinate {
    [self.navigationController popViewControllerAnimated:YES];
    
    CRDialogObject *object = viewController.dialogObject;
    
    [self answerCommandWithObject:object data:@{@"lat": [NSString stringWithFormat:@"%f", coordinate.latitude],
                                                @"lng": [NSString stringWithFormat:@"%f", coordinate.longitude]}];
}

#pragma mark - Lazy loading

- (NSMutableArray *)tableData {
    if (!_tableData) {
        _tableData = [[NSMutableArray alloc] init];
    }
    
    return _tableData;
}

#pragma mark - UIKeyboardWillChangeFrameNotification

- (void)handleKeyboardhNotification:(NSNotification *)notification {
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    keyboardFrame = [self.view convertRect:keyboardFrame fromView:nil];
    
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    self.messagePlaceholderBottomConstraint.constant = self.view.frame.size.height - keyboardFrame.origin.y;
    [self.view setNeedsUpdateConstraints];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    [self.view layoutIfNeeded];
    
    if (self.tableData.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.tableData.count - 1) inSection:0];
        
        [self.dialogTableView scrollToRowAtIndexPath:indexPath
                                    atScrollPosition:UITableViewScrollPositionBottom
                                            animated:YES];
    }
    
    [UIView commitAnimations];
}

#pragma mark - Action section

- (IBAction)sendButtonTouched:(UIButton *)sender {
    CRDialogObject *message = [[CRDialogObject alloc] init];
    message.author = self.nickname;
    message.message = self.messageTextView.text;
    
    [self.socketIO emit:@"message" with:@[[message jsonObject]]];
    [self handleDialogObjects:@[message]];
    
    self.messageTextView.text = @"";
    self.sendButton.enabled = NO;
}

- (void)commandButtonTouched:(UIButton *)sender {
    CRDialogObject *command = [[CRDialogObject alloc] init];
    command.author = self.nickname;
    command.command = [[CRCommand alloc] init];
    
    [self.socketIO emit:@"command" with:@[[command jsonObject]]];
}

- (void)tapGestureTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.messageTextView resignFirstResponder];
}

@end
