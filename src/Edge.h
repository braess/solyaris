//
//  Edge.h
//  IMDG
//
//  Created by CNPP on 22.5.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#pragma once
#include "Node.h"
#include "GraphSettings.h"
#include "cinder/Color.h"
#include <boost/ptr_container/ptr_vector.hpp>
#include <boost/shared_ptr.hpp>


// namespace
using namespace std;
using namespace ci;

// declarations
class Edge;

// typedef
typedef boost::shared_ptr<Edge> EdgePtr;
typedef std::vector<EdgePtr> EdgeVectorPtr;
typedef EdgeVectorPtr::iterator EdgeIt;


// constants
const string edgeMovie = "movie";	
const string edgeActor = "actor";
const string edgeDirector = "director";


/**
 * Graph Edge.
 */
class Edge {
    
    
    // public
    public:
    
    // Edge
    Edge();
    Edge(string ide, NodePtr n1, NodePtr n2); 
    
    // Cinder
    void setting(GraphSettings s);
    
    // Sketch
    void update();
    void draw();
    
    // Business
    void repulse();
    void hide();
    void show();
    void renderLabel(string lbl);
    bool isActive();
    bool isVisible();
    bool isTouched();
    string info();
    
    
    // Public Fields
    string eid;
    NodeWeakPtr wnode1;
    NodeWeakPtr wnode2;
    string label;
    string type;
    
    
    // private
    private:
    
    // States
    bool active;
    bool visible;
    bool selected;
    
    // parameters
    double length;
    double stiffness;
    double damping;
    
    // position
    Vec2d pos;
    
    // color
    Color cstroke;
    Color cstrokea;
    Color cstrokes;
    Color ctxt;
    Color ctxts;
    
    // Font
    Font font;
    Vec2d loff;
    gl::Texture	textureLabel;

};

class EdgeMovie: public Edge {
    
    // public
    public:
    
    // Node
    EdgeMovie();
    EdgeMovie(string ide, NodePtr n1, NodePtr n2);
};
class EdgeActor: public Edge {
    
    // public
    public:
    
    // Node
    EdgeActor();
    EdgeActor(string ide, NodePtr n1, NodePtr n2);
};
class EdgeDirector: public Edge {
    
    // public
    public:
    
    // Node
    EdgeDirector();
    EdgeDirector(string ide, NodePtr n1, NodePtr n2);
};