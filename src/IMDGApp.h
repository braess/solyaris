//
//  IMDGApp.h
//  IMDG
//
//  Created by CNPP on 4.6.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#import <UIKit/UIKit.h>
#include "cinder/app/AppCocoaTouch.h"
#include "Graph.h"
#include "IMDGViewController.h"


// namespace
using namespace std;
using namespace ci;
using namespace ci::app;



/**
 * IMDG App.
 */
class IMDGApp : public AppCocoaTouch {
    
    // Methods
    public:

    // Cinder
    void prepareSettings(Settings *settings);
	void setup();
    
    // Sketch
	void update();
	void draw();
    void reset();
    
    
    // Touch
    void touchesBegan(TouchEvent event);
	void touchesMoved(TouchEvent event);
	void touchesEnded(TouchEvent event);
    
    // Business
    void test();
    
    
    // Fields
    private:
    
    // View controllers
	IMDGViewController *imdgViewController;
    
    // Graph
    Graph graph;
    
    // color
    Color bg;
    
};
