//
//  Graph.h
//  Solyaris
//
//  Created by CNPP on 22.5.2011.
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

#include "cinder/app/AppCocoaTouch.h"
#include "cinder/app/TouchEvent.h"
#include "cinder/gl/gl.h"
#include "cinder/gl/Texture.h"
#include "cinder/ImageIo.h"
#include "cinder/Rand.h"
#include "cinder/audio/Output.h"
#include "cinder/audio/Io.h"
#include "Node.h"
#include "Edge.h"
#include "Tooltip.h"
#include "Action.h"
#include "GraphSettings.h"
#include "Resources.h"
#include "I18N.h"
#include <vector>
#include <map>



// namespace
using namespace ci;
using namespace ci::app;
using namespace std;


/**
 * Graph.
 */
class Graph {
        
    // public
    public:
    
    // Graph
    Graph();
    Graph(int w, int h, int o);

    // Cinder
    void resize(int w, int h, int o);
    void setting(GraphSettings s);
    void i18n(I18N tls);
    
    
    // Sketch
    void reset();
    void update();
    void draw();
    
    // Touch
	void touchBegan(Vec2d tpos, int tid);
    void touchMoved(Vec2d tpos, Vec2d ppos, int tid);
    void touchEnded(Vec2d tpos, int tid);
    
    // Tap
    NodePtr doubleTap(Vec2d tpos, int tid);
    
    // Gestures
    void pinched(Vec2d p, Vec2d pp, double s, double ps);
    
    
    // Business
    void attract();
    void repulse();
    void subnodes();
    void move(Vec2d d);
    void drag(Vec2d d);
    NodePtr createNode(string nid, string type);
    NodePtr createNode(string nid, string type, double x, double y);
    NodePtr getNode(string nid);
    EdgePtr createEdge(string eid, string type, NodePtr n1, NodePtr n2);
    EdgePtr getEdge(string nid1, string nid2);
    void load(NodePtr n);
    void unload(NodePtr n);
    bool onStage(NodePtr n);
    void tooltip(int tid);
    void action(int tid);
    void sample(int s);
    void removeNode(string nid);
    
    
    // private
    private:
    
    // size
    int width;
    int height;
    int orientation;
    float speed;
    float friction;
    float harea;
    bool layout_nodes, layout_subnodes;
    gl::Texture background;
    
    
    // data
    NodeVectorPtr nodes;
    EdgeVectorPtr edges;
    
    // maps
    map<string,int>nmap;
    map<string,int>emap;
    
    // virtual offset
    Vec2d voff;
    Vec2d vpoff;
    Vec2d vmoff;
    
    // virtual position
    Vec2d vpos;
    Vec2d vppos;
    Vec2d vmpos;
    
    // bound
    float mbound;
    
    // zoom
    Vec2d translate;
    double scale;

    
    // touched nodes
    int nbtouch;
    map<int, NodePtr> touched;
    
    // tooltips
    map<int, Tooltip> tooltips;
    
    // actions
    map<int, Action> actions;
    
    // settings
    GraphSettings gsettings;
    
    // samples
    audio::SourceRef audioSampleClick;
    
    // translations
    I18N translations;
    
};

