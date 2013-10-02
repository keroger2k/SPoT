//
//  ImageViewController.m
//  Shutterbug
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation ImageViewController

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (self.image) {
        self.scrollView.zoomScale = 1.0;
        self.scrollView.contentSize = self.image.size;
        self.imageView.image = self.image;
        self.imageView.frame = CGRectMake(0, 0, self.image.size.width + 100, self.image.size.height + 100);
    }
}

- (void)resetImage
{
    if (self.scrollView) {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        [self.spinner startAnimating];
        dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
        dispatch_async(downloadQueue, ^{
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
            self.image = [[UIImage alloc] initWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.image) {
                    self.scrollView.zoomScale = 1.0;
                    self.scrollView.contentSize = self.image.size;
                    self.imageView.image = self.image;
                    self.imageView.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
                }
                [self.spinner stopAnimating];
            });
        });
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;
    [self resetImage];
}

@end
