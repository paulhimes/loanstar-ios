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
@property (weak, nonatomic) IBOutlet UISegmentedControl *formatPicker;
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
    if (self.item.year > 0) {
        self.yearField.text = [NSString stringWithFormat:@"%d", self.item.year];
    }
    if (self.item.picture) {
        [self.pictureButton setImage:self.item.picture forState:UIControlStateNormal];
    }
    
    if (self.item.format == [Format vhs]) {
        self.formatPicker.selectedSegmentIndex = 0;
    } else if (self.item.format == [Format dvd]) {
        self.formatPicker.selectedSegmentIndex = 1;
    } else if (self.item.format == [Format bluray]) {
        self.formatPicker.selectedSegmentIndex = 2;
    }
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
        self.item.title = self.titleField.text;
        NSInteger year = [self.yearField.text integerValue];
        if (year > 0) {
            self.item.year = [self.yearField.text integerValue];
        }
        
        switch (self.formatPicker.selectedSegmentIndex) {
            case 0:
                self.item.format = [Format vhs];
                break;
            case 1:
                self.item.format = [Format dvd];
                break;
            case 2:
                self.item.format = [Format bluray];
                break;
            default:
                break;
        }

        self.item.picture = [self.pictureButton imageForState:UIControlStateNormal];
        
        [ServerAdapter editItem:self.item];
        [self dismiss];
    } else {
        Item *item = [[Item alloc] init];
        // Fill in item details.
        item = [ServerAdapter createItem:item];
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
    self.item.picture = [self scaleAndCropImage:image toSize:CGSizeMake(320, 240)];
    if (self.item.picture) {
        [self.pictureButton setImage:self.item.picture forState:UIControlStateNormal];
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
