//
//  CRLoginViewController.m
//  Chat Room
//
//  Created by Anatoli Tauhen on 20.09.16.
//  Copyright © 2016 Ottonova. All rights reserved.
//

#import "CRLoginViewController.h"
#import "CRChatViewController.h"


static NSString *const kCRSegueIdentifierChat = @"CRSegueIdentifierChat";


@interface CRLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;

@end


@implementation CRLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kCRSegueIdentifierChat]) {
        CRChatViewController *chatViewController = segue.destinationViewController;
        chatViewController.nickname = self.nicknameTextField.text;
    }
}

#pragma mark - Action section

- (IBAction)enterButtonTouched:(UIButton *)sender {
    if ([_nicknameTextField.text isEqualToString:@""]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"Nickname must contain at least one character."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {

        }];
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self performSegueWithIdentifier:kCRSegueIdentifierChat sender:self];
    }
}

@end
