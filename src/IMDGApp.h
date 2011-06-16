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

    // Cinder
    public:
    void prepareSettings(Settings *settings);
	void setup();
	void update();
	void draw();
    
    void touchesBegan(TouchEvent event);
	void touchesMoved(TouchEvent event);
	void touchesEnded(TouchEvent event);
    
    // Business
    void test();
    
    // View controllers
	IMDGViewController *imdgViewController;
    
    // Fields
    private:
    Graph graph;
    
    // color
    Color bg;
    
};
