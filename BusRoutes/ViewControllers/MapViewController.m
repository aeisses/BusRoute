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
        
        legendView = [[[[NSBundle mainBundle] loadNibNamed:@"LegendView" owner:self options:nil] objectAtIndex:0] retain];
        legendView.delegate = self;
        
        showNumberOfRoutesStops = NO;
        isDrawing = NO;
        
        drawingImageView = [[DrawingImageView alloc] initWithFrame:self.view.frame];
        
        saveButton = [[UIButton alloc] initWithFrame:(CGRect){960,620,40,40}];
        [saveButton addTarget:self action:@selector(touchSaveButton) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setImage:[UIImage imageNamed:@"saveButton.png"] forState:UIControlStateNormal];
        
        clearButton = [[UIButton alloc] initWithFrame:(CGRect){960,700,40,40}];
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
    [drawingImageView removeAllBusRoutesFromMap:_mapView];
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
        [self hideHudView];
        [legendView cleanLegend];
        dispatch_queue_t loadDataQueue  = dispatch_queue_create("load data queue", NULL);
        dispatch_async(loadDataQueue, ^{
            [self addProgressIndicator];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_mapView removeAnnotations:[_delegate getStops]];
            });
            [_delegate showRoutes];
            dispatch_async(dispatch_get_main_queue(), ^{
                [legendView cleanLegend];
            });
        });
        dispatch_release(loadDataQueue);
    } else if (button.tag == 2) {
        [self hideHudView];
        [legendView cleanLegend];
        dispatch_queue_t loadDataQueue  = dispatch_queue_create("load data queue", NULL);
        dispatch_async(loadDataQueue, ^{
            [self addProgressIndicator];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_mapView removeAnnotations:[_delegate getStops]];
            });
            for (BusRoute *busRoute in [_delegate getRoutes]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_mapView removeOverlays:busRoute.lines];
                });
            }
            showNumberOfRoutesStops = NO;
            showTerminals = NO;
            [_delegate showStopsWithValue:-1 isTerminal:NO];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addLegendElementWithTitle:@"All Bus Stops" andImage:[UIImage imageNamed:@"dot0.png"]];
            });
        });
        dispatch_release(loadDataQueue);
    } else if (button.tag == 3) {
        if (popOverController == nil) {
            [popOverController dismissPopoverAnimated:NO];
            [popOverController release];
        }
        NumericNodeTable *table = [[NumericNodeTable alloc] initWithNibName:@"NumericNodeTableViewController" bundle:[NSBundle mainBundle]];
        table.delegate = self;
        popOverController = [[UIPopoverController alloc] initWithContentViewController:table];
        [table release];
        [popOverController presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else if (button.tag == 4) {
        if (popOverController == nil) {
            [popOverController dismissPopoverAnimated:NO];
            [popOverController release];
        }
        TerminalTable *table = [[TerminalTable alloc] initWithNibName:@"TerminalTable" bundle:[NSBundle mainBundle]];
        table.delegate = self;
        popOverController = [[UIPopoverController alloc] initWithContentViewController:table];
        [popOverController setPopoverContentSize:(CGSize){320,400}];
        [table release];
        [popOverController presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else if (button.tag == 5) {
        [self hideHudView];
        legendView.frame = (CGRect){50,200,legendView.frame.size};
        [self.view addSubview:legendView];
        [self hideHudView];
    } else if (button.tag == 6) {
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
    } else if (button.tag == 7) {
        [_mapView addGestureRecognizer:touchDown];
    } else if (button.tag == 8) {
        if (isDrawing) {
            [drawingImageView removeFromSuperview];
            [saveButton removeFromSuperview];
            [clearButton removeFromSuperview];
            [deleteButton removeFromSuperview];
            [createRoute removeFromSuperview];
            [reverseButton removeFromSuperview];
            isDrawing = NO;
        } else {
            [self.view insertSubview:drawingImageView belowSubview:_toolBar];
            [self.view addSubview:saveButton];
            [self.view addSubview:clearButton];
            [self.view addSubview:deleteButton];
            [self.view addSubview:createRoute];
            [self.view addSubview:reverseButton];
            isDrawing = YES;
        }
    } else if (button.tag == 9) {
        PruneViewController *pruneVC = [[[PruneViewController alloc] initWithNibName:@"PruneViewController" bundle:nil] autorelease];
        pruneVC.delegate = self;
        CGRect origFrame = pruneVC.view.frame;
        pruneVC.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:pruneVC animated:YES completion:^{
        }];
        pruneVC.view.superview.bounds = origFrame;
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
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [drawingImageView showBusRoute:_mapView];
    [super touchesEnded:touches withEvent:event];
}

- (void)viewDidLoad
{
    _mapView.scrollEnabled = NO;
    _mapView.zoomEnabled = NO;
    _toolBar.hidden = YES;
    [self.view bringSubviewToFront:_toolBar];
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
    MKMapView *mapView = (MKMapView *)tapGesture.view;
    id<MKOverlay> tappedOverlay = nil;
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
                tappedOverlay = overlay;
                break;
            }
        }
    }
    NSLog(@"Tapped view: %@", [mapView viewForOverlay:tappedOverlay]);
    [_mapView removeOverlay:tappedOverlay];
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
        [self enableGestures];
        dispatch_async(dispatch_get_main_queue(), ^{
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
    [swipeDown release]; swipeDown = nil;
    [swipeUp release]; swipeUp = nil;
    [legendView release]; legendView = nil;
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
}

- (void)disableGestures
{
    swipeDown.enabled = NO;
    swipeUp.enabled = NO;
}

#pragma InfoViewControllerDelegate Methods
- (void)positiveButtonTouchedForInfo:(INFO)info
{
    switch (info) {
        case reverse:
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

#pragma NumericNodeTableDelegate Methods
- (void)touchedTableElement:(NSInteger)element
{
    [popOverController dismissPopoverAnimated:NO];
    [self hideHudView];
    if (!showNumberOfRoutesStops)
    {
        [_delegate clearSets];
        [legendView cleanLegend];
    }
    dispatch_queue_t loadDataQueue  = dispatch_queue_create("load data queue", NULL);
    dispatch_async(loadDataQueue, ^{
        [self addProgressIndicator];
        showNumberOfRoutesStops = YES;
        showTerminals = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mapView removeAnnotations:[_delegate getStops]];
        });
        for (BusRoute *busRoute in [_delegate getRoutes]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_mapView removeOverlays:busRoute.lines];
            });
        }
        [_delegate showStopsWithValue:element isTerminal:NO];
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

- (void)freeZoom
{
    [popOverController dismissPopoverAnimated:NO];
    _mapView.scrollEnabled = YES;
    _mapView.zoomEnabled = YES;
}

- (void)lockZoom
{
    [popOverController dismissPopoverAnimated:NO];
    _mapView.scrollEnabled = NO;
    _mapView.zoomEnabled = NO;
}

#pragma TerminaTableDelegate Methods
- (void)touchedTerminalTableElement:(NSInteger)element
{
    [popOverController dismissPopoverAnimated:NO];
    [self hideHudView];
    if (!showTerminals){
        [_delegate clearSets];
        [legendView cleanLegend];
    }
    dispatch_queue_t loadDataQueue  = dispatch_queue_create("load data queue", NULL);
    dispatch_async(loadDataQueue, ^{
        [self addProgressIndicator];
        showNumberOfRoutesStops = NO;
        showTerminals = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mapView removeAnnotations:[_delegate getStops]];
        });
        for (BusRoute *busRoute in [_delegate getRoutes]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_mapView removeOverlays:busRoute.lines];
            });
        }
        [_delegate showStopsWithValue:element isTerminal:YES];
    });
    dispatch_release(loadDataQueue);
}

#pragma Common Delegate Method from TerminaTableDelegate and NumericNodeTableDelegate
- (void)addLegendElementWithTitle:(NSString*)title andImage:(UIImage*)image
{
    [legendView addLegendElement:title andImage:image];
}

- (void)clearLegend
{
    [legendView cleanLegend];
}

#pragma LegendViewDelegate Methods
- (void)exitLegendView
{
    [legendView removeFromSuperview];
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
    if (isDrawing) {
        polylineView.strokeColor = [UIColor orangeColor];
    } else {
        polylineView.strokeColor = [UIColor blackColor];
    }
    polylineView.lineJoin = kCGLineCapButt;
    polylineView.lineWidth = 2.0;
    
    return polylineView;
}

- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews {
    loadingBusRouteCounter--;
    [self removeProgressIndicator];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    BusStop *busStop = view.annotation;
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
    } else  if (isDrawing) {
        [drawingImageView addLineFrom:prevBusStop To:busStop forMapView:_mapView];
        [prevBusStop release];
        prevBusStop = nil;
        prevBusStop = [busStop retain];
    }
}

@end
