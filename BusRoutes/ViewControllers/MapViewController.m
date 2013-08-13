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
        
        pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(fingerMoved:)];
        
        legendView = [[[[NSBundle mainBundle] loadNibNamed:@"LegendView" owner:self options:nil] objectAtIndex:0] retain];
        legendView.delegate = self;
        
        showNumberOfRoutesStops = NO;
    }
    return self;
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
        if ([[self.view gestureRecognizers] containsObject:pan]) {
            [_mapView removeGestureRecognizer:pan];
        } else {
            [_mapView addGestureRecognizer:pan];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (date != nil) {
        [date release];
        date = [[NSDate alloc] init];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _mapView.scrollEnabled = NO;
    _mapView.zoomEnabled = NO;
    _toolBar.hidden = YES;
    [self.view bringSubviewToFront:_toolBar];
    [self.view addGestureRecognizer:swipeDown];
    [self.view addGestureRecognizer:swipeUp];
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(frameIntervalLoop:)];
    [displayLink setFrameInterval:15];
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

- (void)fingerMoved:(UIPanGestureRecognizer*)panGesture
{
    NSLog(@"Pan: %@",panGesture);
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
    _delegate = nil;
}

#pragma Private Methods
- (void)frameIntervalLoop:(CADisplayLink *)sender
{
    if (!_toolBar.hidden && !_mapView.scrollEnabled && !_mapView.zoomEnabled && ![[self.view gestureRecognizers] containsObject:pan]) {
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
            annotationView.enabled = NO;
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
    polylineView.strokeColor = [UIColor blackColor];
    polylineView.lineJoin = kCGLineCapButt;
    polylineView.lineWidth = 2.0;
    
    return polylineView;
}

- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews {
    loadingBusRouteCounter--;
    [self removeProgressIndicator];
}

@end
