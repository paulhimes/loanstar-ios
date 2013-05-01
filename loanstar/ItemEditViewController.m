//
//  ItemEditViewController.m
//  loanstar
//
//  Created by Paul Himes on 4/14/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "ItemEditViewController.h"
#import "Format.h"
#import "ServerAdapter.h"
#import "MockServerAdapter.h"

@interface ItemEditViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *yearField;
@property (weak, nonatomic) IBOutlet UITextField *formatField;
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;

@end

@implementation ItemEditViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = self.item.title;
    self.titleField.text = self.item.title;
    self.yearField.text = [NSString stringWithFormat:@"%d", self.item.year];
    self.formatField.text = self.item.format.name;
}

- (IBAction)changePicture:(id)sender {
    
    UIActionSheet *actionSheet;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Library", @"Camera", nil];
    } else {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Library", nil];
    }
    
    [actionSheet showInView:self.view];
}

- (IBAction)saveButtonPressed:(id)sender {
    if (self.item) {
        // Update item details.
        [ServerAdapter editItem:self.item error:NULL];
        [self dismiss];
    } else {
        Item *item = [[Item alloc] init];
        // Fill in item details.
        item = [ServerAdapter createItem:item error:NULL];
        [self dismiss];
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismiss];
}

- (void)dismiss
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    switch (buttonIndex) {
        case 0:
            // Library
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:^{}];
            break;
        case 1:
            // Camera
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:^{}];
            }
            break;
        case 2:
            // Cancel
            
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (image) {
        [self.pictureButton setImage:[self scaleAndCropImage:image toSize:CGSizeMake(320, 240)] forState:UIControlStateNormal];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (UIImage*)scaleAndCropImage:(UIImage*)image toSize:(CGSize)size
{
    double imageWidthHeightRatio = image.size.width / image.size.height;
    CGSize destinationSize = size;
    
    // Try scaling to equal widths.
    if (size.width / imageWidthHeightRatio >= size.height) {
        // This will work.
        destinationSize = CGSizeMake(size.width, size.width / imageWidthHeightRatio);
    }
    
    // Try scaling to equal heights.
    if (size.height * imageWidthHeightRatio >= size.width) {
        // This will work.
        destinationSize = CGSizeMake(size.height * imageWidthHeightRatio, size.height);
    }
    
    // Scale and crop the image.
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [image drawInRect:CGRectMake((size.width - destinationSize.width) / 2.0, (size.height - destinationSize.height) / 2.0, destinationSize.width, destinationSize.height)];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return croppedImage;
}

@end
