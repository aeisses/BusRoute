//
//  MapViewController.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-22.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreenDown:)];
        swipeDown.numberOfTouchesRequired = 1;
        swipeDown.direction = (UISwipeGestureRecognizerDirectionDown);
        
        swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreenUp:)];
        swipeUp.numberOfTouchesRequired = 1;
        swipeUp.direction = (UISwipeGestureRecognizerDirectionUp);
        
        touchDown = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped:)];
        touchDown.numberOfTapsRequired = 2;
        
        showNumberOfRoutesStops = NO;
        isDrawing = NO;
        
        drawingImageView = [[DrawingImageView alloc] initWithFrame:self.view.frame];
        
        saveButton = [[UIButton alloc] initWithFrame:(CGRect){960,549,40,40}];
        [saveButton addTarget:self action:@selector(touchSaveButton) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setImage:[UIImage imageNamed:@"saveButton.png"] forState:UIControlStateNormal];
        
        clearButton = [[UIButton alloc] initWithFrame:(CGRect){960,620,40,40}];
        [clearButton addTarget:self action:@selector(touchClearButton) forControlEvents:UIControlEventTouchUpInside];
        [clearButton setImage:[UIImage imageNamed:@"clearButton.png"] forState:UIControlStateNormal];

        deleteButton = [[UIButton alloc] initWithFrame:(CGRect){20,620,40,40}];
        [deleteButton addTarget:self action:@selector(touchDeleteButton) forControlEvents:UIControlEventTouchUpInside];
        [deleteButton setImage:[UIImage imageNamed:@"deleteButton"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"deleteButtonSelected"] forState:UIControlStateSelected];
        
        createRoute = [[UIButton alloc] initWithFrame:(CGRect){20,700,40,40}];
        [createRoute addTarget:self action:@selector(touchCreateRouteButton) forControlEvents:UIControlEventTouchUpInside];
        [createRoute setImage:[UIImage imageNamed:@"createRoute"] forState:UIControlStateNormal];
        
        reverseButton = [[UIButton alloc] initWithFrame:(CGRect){15,540,50,40}];
        [reverseButton addTarget:self action:@selector(touchReverseButton) forControlEvents:UIControlEventTouchUpInside];
        [reverseButton setImage:[UIImage imageNamed:@"reversed"] forState:UIControlStateNormal];
         
        saveViewController = [[SaveViewController alloc] initWithNibName:@"SaveViewController" bundle:nil];
        saveViewController.delegate = self;
        counter = 0;
    }
    return self;
}

- (void)touchSaveButton
{
    saveViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    CGRect origFrame = saveViewController.view.frame;
    [self presentViewController:saveViewController animated:YES completion:^{
        
    }];
    saveViewController.view.superview.bounds = origFrame;
}

- (void)touchClearButton
{
    dispatch_queue_t drawingQueue  = dispatch_queue_create("load data queue", NULL);
    dispatch_async(drawingQueue, ^{
        [drawingImageView removeAllBusRoutesFromMap:_mapView];
    });
    dispatch_release(drawingQueue);
}

- (void)touchCreateRouteButton
{
    deleteButton.selected = NO;
    createRoute.selected = !createRoute.selected;
}

- (void)touchDeleteButton
{
    createRoute.selected = NO;
    deleteButton.selected = !deleteButton.selected;
}

- (void)touchReverseButton
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"ReverseInfoWindow"]) {
        InfoViewController *infoVC = [[[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil] autorelease];
        infoVC.delegate = self;
        CGRect origFrame = infoVC.view.frame;
        infoVC.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:infoVC animated:YES completion:^{
        }];
        infoVC.view.superview.bounds = origFrame;
    } else {
        [drawingImageView reverseRoute];
    }
}

- (IBAction)titleBarButtonTouched:(id)sender
{
    UIBarButtonItem *button = (UIBarButtonItem*)sender;
    if (button.tag == 1) {
        if (popOverController == nil) {
            [popOverController dismissPopoverAnimated:NO];
            [popOverController release];
        }
        LocationsTable *table = [[LocationsTable alloc] initWithNibName:@"LocationsTable" bundle:[NSBundle mainBundle]];
        table.delegate = self;
        popOverController = [[UIPopoverController alloc] initWithContentViewController:table];
        [popOverController setPopoverContentSize:(CGSize){320,400}];
        [table release];
        [popOverController presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else if (button.tag == 2) {
        if (isDrawing) {
            [drawingImageView removeFromSuperview];
            [saveButton removeFromSuperview];
            [clearButton removeFromSuperview];
            [deleteButton removeFromSuperview];
            [createRoute removeFromSuperview];
            [reverseButton removeFromSuperview];
            [_mapView removeGestureRecognizer:touchDown];
            isDrawing = NO;
        } else {
            [self.view insertSubview:drawingImageView belowSubview:_toolBar];
            [self.view addSubview:saveButton];
            [self.view addSubview:clearButton];
            [self.view addSubview:deleteButton];
            [self.view addSubview:createRoute];
            [self.view addSubview:reverseButton];
            [_mapView addGestureRecognizer:touchDown];
            isDrawing = YES;
        }
    } else if (button.tag == 3) {
        PruneViewController *pruneVC = [[[PruneViewController alloc] initWithNibName:@"PruneViewController" bundle:nil] autorelease];
        pruneVC.delegate = self;
        CGRect origFrame = pruneVC.view.frame;
        pruneVC.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:pruneVC animated:YES completion:^{
        }];
        pruneVC.view.superview.bounds = origFrame;
    } else if (button.tag == 4) {
        
    }
}

- (IBAction)touchZoomButton:(id)sender
{
    _zoomButton.selected = !_zoomButton.selected;
    if (!_zoomButton.selected) {
        _mapView.scrollEnabled = YES;
        _mapView.zoomEnabled = YES;
    } else {
        _mapView.scrollEnabled = NO;
        _mapView.zoomEnabled = NO;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (date != nil) {
        [date release];
        date = [[NSDate alloc] init];
    }
    if (prevBusStop)
    {
        [prevBusStop release];
        prevBusStop = nil;
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    isMoving = YES;
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    dispatch_queue_t drawingQueue  = dispatch_queue_create("load data queue", NULL);
    dispatch_async(drawingQueue, ^{
        if (isDrawing && isMoving)
            [drawingImageView endLine:_mapView];
        isMoving = NO;
    });
    dispatch_release(drawingQueue);
    [super touchesEnded:touches withEvent:event];
}

- (void)viewDidLoad
{
    _mapView.scrollEnabled = NO;
    _mapView.zoomEnabled = NO;
    _toolBar.hidden = YES;
    [self.view bringSubviewToFront:_toolBar];
    [self.view bringSubviewToFront:_zoomButton];
    [self.view addGestureRecognizer:swipeDown];
    [self.view addGestureRecognizer:swipeUp];
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(frameIntervalLoop:)];
    [displayLink setFrameInterval:15];
    [super viewDidLoad];
}

- (void)swipedScreenUp:(UISwipeGestureRecognizer*)swipeGesture
{
    [self hideHudView];
}

- (void)swipedScreenDown:(UISwipeGestureRecognizer*)swipeGesture
{
    [self showHudView];
}

- (void)mapTapped:(UITapGestureRecognizer*)tapGesture
{
    dispatch_queue_t drawingQueue  = dispatch_queue_create("load data queue", NULL);
    dispatch_async(drawingQueue, ^{
        // TODO: This is not working right, the frame of the routes is to big, need to do something else.
        MKMapView *mapView = (MKMapView *)tapGesture.view;
        for (id<MKOverlay> overlay in mapView.overlays)
        {
            MKOverlayView *view = [mapView viewForOverlay:overlay];
            if (view)
            {
                // Get view frame rect in the mapView's coordinate system
                CGRect viewFrameInMapView = [view.superview convertRect:view.frame toView:mapView];
                // Get touch point in the mapView's coordinate system
                CGPoint point = [tapGesture locationInView:mapView];
                // Check if the touch is within the view bounds
                if (CGRectContainsPoint(viewFrameInMapView, point))
                {
                    if (![overlay.subtitle isEqualToString:@"-1"])
                        [drawingImageView setActiveLine:overlay.subtitle forMapView:_mapView];
                    break;
                }
            }
        }
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView setRegion:[RegionZoomData getRegion:HRM] animated:NO];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    if (date != nil) {
        [date release];
        date = [[NSDate alloc] init];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)addBusStop:(BusStop*)busStop
{
    loadingBusStopCounter++;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_mapView addAnnotation:busStop];
    });
}

- (void)addRoute:(BusRoute*)route
{
    loadingBusRouteCounter++;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_mapView addOverlays:route.lines];
    });
}

- (void)addProgressIndicator
{
    if (activityIndicator == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            activityIndicator.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
            [activityIndicator hidesWhenStopped];
        });
    }
    [self disableGestures];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:activityIndicator];
        [activityIndicator startAnimating];
    });
}

- (void)removeProgressIndicator
{
    if (!_isDataLoading && !loadingBusStopCounter && !loadingBusRouteCounter) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self enableGestures];
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
        });
    }
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    activityIndicator.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
}

- (void)dealloc
{
    [super dealloc];
    [_mapView release]; _mapView = nil;
    [_zoomButton release]; _zoomButton = nil;
    [_toolBar release]; _toolBar = nil;
    [swipeDown release]; swipeDown = nil;
    [swipeUp release]; swipeUp = nil;
    [touchDown release]; touchDown = nil;
    [popOverController release]; popOverController = nil;
    [drawingImageView release]; drawingImageView = nil;
    [saveViewController release]; saveViewController = nil;
    [clearButton release]; clearButton = nil;
    [saveButton release]; saveButton = nil;
    [deleteButton release]; deleteButton = nil;
    [reverseButton release]; reverseButton = nil;
    _delegate = nil;
}

#pragma Private Methods
- (void)frameIntervalLoop:(CADisplayLink *)sender
{
    if (!_toolBar.hidden && !_mapView.scrollEnabled && !_mapView.zoomEnabled && !isDrawing) {
        if (date == nil) {
            date = [[NSDate alloc] init];
        }
        if ([date timeIntervalSinceNow] < WINDOWS_AUTO_CLOSE) {
            [self hideHudView];
            [date release]; date = nil;
        }
    }
}

- (void)hideHudView
{
    [popOverController dismissPopoverAnimated:NO];
    if (!_mapView.scrollEnabled && !_mapView.zoomEnabled)
        [UIView animateWithDuration:0.5 animations:^{
            _toolBar.hidden = YES;
        }];
}

- (void)showHudView
{
    [UIView animateWithDuration:0.5 animations:^{
        _toolBar.hidden = NO;
    }];
}

- (void)enableGestures
{
    swipeDown.enabled = YES;
    swipeUp.enabled = YES;
    _zoomButton.enabled = YES;
    if (!_zoomButton.selected) {
        _mapView.scrollEnabled = YES;
        _mapView.zoomEnabled = YES;
    } else {
        _mapView.scrollEnabled = NO;
        _mapView.zoomEnabled = NO;
    }
}

- (void)disableGestures
{
    swipeDown.enabled = NO;
    swipeUp.enabled = NO;
    _zoomButton.enabled = NO;
}

#pragma SaveViewControllerDelegate Methods
- (void)createRouteWithValue:(NSDictionary*)values
{
    [drawingImageView createBusRouteOnMap:_mapView
                                withName:[values objectForKey:@"Name"]
                                andNumber:[values objectForKey:@"Number"]
                            andDescription:[values objectForKey:@"Description"]
                            andIsReversed:(BOOL)[(NSNumber*)[values objectForKey:@"isReverse"] integerValue]];
}


#pragma InfoViewControllerDelegate Methods
- (void)positiveButtonTouchedForInfo:(INFO)info
{
    switch (info) {
        case reverseInfo:
            [drawingImageView reverseRoute];
            break;
    }
}

#pragma PruneViewControllerDelegate Methods
- (void)pruneRoutesMetroX:(BOOL)metroX andMetroLink:(BOOL)metroLink andExpressRoute:(BOOL)expressRoute
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHudView];
        [_mapView removeAnnotations:[_delegate getStops]];
    });
    dispatch_queue_t loadDataQueue  = dispatch_queue_create("load data queue", NULL);
    dispatch_async(loadDataQueue, ^{
        [self addProgressIndicator];
        [_delegate pruneRoutesMetroX:metroX andMetroLink:metroLink andExpressRoute:expressRoute];
    });
    dispatch_release(loadDataQueue);
}

#pragma LocationsTableDelegate Methods
- (void)touchedLocationTable:(REGION)region
{
    [popOverController dismissPopoverAnimated:NO];
    _mapView.scrollEnabled = NO;
    _mapView.zoomEnabled = NO;
    [_mapView setRegion:[RegionZoomData getRegion:region] animated:NO];
    [self hideHudView];
}

#pragma MKMapViewDelegate Methods
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BusStop class]]) {
        NSString *identifier;
        if (!showNumberOfRoutesStops && !showTerminals) {
            identifier = @"BusStop";
        } else if (!showNumberOfRoutesStops && showTerminals) {
            BusStop *busStop = (BusStop*)annotation;
            identifier = [NSString stringWithFormat:@"Terminal%i",busStop.fcode];
        } else {
            BusStop *busStop = (BusStop*)annotation;
            identifier = [NSString stringWithFormat:@"BusStop%i",[busStop.routes count]];
        }
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
            annotationView.enabled = YES;
            annotationView.canShowCallout = NO;
            NSString *imageName;
            if (!showNumberOfRoutesStops && !showTerminals) {
                imageName = @"dot0.png";
            } else if (!showNumberOfRoutesStops && showTerminals) {
                BusStop *busStop = (BusStop*)annotation;
                imageName = [NSString stringWithFormat:@"terminal%i",busStop.fcode];
            } else {
                BusStop *busStop = (BusStop*)annotation;
                imageName = [NSString stringWithFormat:@"dot%i.png",[busStop.routes count]];
            }
            annotationView.image = [UIImage imageNamed:imageName];//here we use a nice image instead of the default pins
        } else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    loadingBusStopCounter--;
    [self removeProgressIndicator];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    
    MKPolylineView *polylineView = [[[MKPolylineView alloc] initWithPolyline:overlay] autorelease];
    if ([overlay.title isEqualToString:@"Black"]) {
        polylineView.strokeColor = [UIColor blackColor];
        polylineView.lineWidth = 2.0;
    } else if ([overlay.title isEqualToString:@"Red"]) {
        polylineView.strokeColor = [UIColor redColor];
        polylineView.lineWidth = 4.0;
    } else if ([overlay.title isEqualToString:@"Blue"]) {
        polylineView.strokeColor = [UIColor blueColor];
        polylineView.lineWidth = 4.0;
    } else if ([overlay.title isEqualToString:@"Green"]) {
        polylineView.strokeColor = [UIColor greenColor];
        polylineView.lineWidth = 4.0;
    }
    polylineView.lineJoin = kCGLineCapButt;
    
    return polylineView;
}

- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews {
    loadingBusRouteCounter--;
    [self removeProgressIndicator];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    dispatch_queue_t drawingQueue  = dispatch_queue_create("load data queue", NULL);
    dispatch_async(drawingQueue, ^{
        BusStop *busStop = view.annotation;
        NSLog(@"Street: %@",busStop.street);
        switch (busStop.direction) {
            case north:
                NSLog(@"Direction: North");
                break;
            case south:
                NSLog(@"Direction: South");
                break;
            case east:
                NSLog(@"Direction: East");
                break;
            case west:
                NSLog(@"Direction: West");
                break;
            case inbound:
                NSLog(@"Direction: Inbound");
                break;
            case outbound:
                NSLog(@"Direction: Outbound");
                break;
            case unknown:
                NSLog(@"Direction: Unknown");
                break;
        }
        if (deleteButton.selected) {
            if (prevBusStop) {
                [prevBusStop release];
                prevBusStop = nil;
            }
            [drawingImageView removeBusStop:busStop fromMapView:_mapView];
        } else if (createRoute.selected) {
            if (prevBusStop) {
                [prevBusStop release];
                prevBusStop = nil;
            }
            [drawingImageView addBusStop:busStop toMapView:_mapView];
        } else if (!prevBusStop && isDrawing) {
            prevBusStop = [busStop retain];
        } else if (isDrawing) {
            if ([prevBusStop.street isEqualToString:busStop.street]) {
                [drawingImageView addLineFrom:prevBusStop To:busStop forMapView:_mapView];
                [prevBusStop release];
                prevBusStop = nil;
                prevBusStop = [busStop retain];
            }
        }
    });
    dispatch_release(drawingQueue);
}

@end
