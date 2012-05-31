//
//  Solyaris.h
//  Solyaris
//
//  Created by CNPP on 4.6.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
//  This file is part of Solyaris.
//  
//  Solyaris is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//  
//  Solyaris is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with Solyaris.  If not, see www.gnu.org/licenses/.

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
    
    // Gestures
    void pinched(UIPinchGestureRecognizer* recognizer); 
    
    
    // Business
    NodePtr createNode(string nid, string type);
    NodePtr createNode(string nid, string type, double x, double y);
    NodePtr getNode(string nid);
    EdgePtr createEdge(string eid, string type, NodePtr n1, NodePtr n2);
    EdgePtr getEdge(string nid1, string nid2);
    ConnectionPtr createConnection(string cid, string type, NodePtr n1, NodePtr n2);
    ConnectionPtr getConnection(string nid1, string nid2);
    void load(NodePtr n);
    void unload(NodePtr n);
    void graphShift(double mx, double my);
    Vec3d nodeCoordinates(NodePtr n);
    
    
    // Fields
    private:
    
    // app
    int orientation;
    double dwidth;
    double dheight;
    bool retina;
    bool redux;
    double pscale;
    CGPoint ppinch;

    // view controllers
	SolyarisViewController *solyarisViewController;
    
    // graph
    Graph graph;
    
    // color
    Color bg;
    
};
