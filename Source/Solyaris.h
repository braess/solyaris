//
//  Solyaris.h
//  Solyaris
//
//  Created by CNPP on 4.6.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#import <UIKit/UIKit.h>
#include "cinder/Cinder.h"
#include "cinder/gl/gl.h"
#include "cinder/app/AppNative.h"
#include "cinder/System.h"
#include "Graph.h"
#include "SolyarisViewController.h"


// namespace
using namespace std;
using namespace ci;
using namespace ci::app;



/**
 * Solyaris App.
 */
class Solyaris : public AppCocoaTouch {
    
    // Methods
    public:

    // Cinder
    void launch( const char *title, int argc, char * const argv[] );
    void prepareSettings(Settings *settings);
	void setup();
    void applyDeviceOrientation(int dorientation);
    void applySettings();
    
    // Sketch
	void update();
	void draw();
    void reset();
    
    
    // Touch
    void touchesBegan( TouchEvent event );
	void touchesMoved( TouchEvent event );
	void touchesEnded( TouchEvent event );
    
    // Business
    NodePtr createNode(string nid, string type, double x, double y);
    NodePtr getNode(string nid);
    EdgePtr createEdge(string eid,string type, NodePtr n1, NodePtr n2);
    EdgePtr getEdge(string nid1, string nid2);
    void load(NodePtr n);
    void unload(NodePtr n);
    
    
    // Fields
    private:
    
    // app
    int orientation;

    // view controllers
	SolyarisViewController *solyarisViewController;
    
    // graph
    Graph graph;
    
    // color
    Color bg;
    
    
};
