//
//  Edge.h
//  Solyaris
//
//  Created by CNPP on 22.5.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#pragma once
#include "Node.h"
#include "GraphSettings.h"
#include "cinder/gl/gl.h"
#include "cinder/Text.h"
#include "cinder/CinderMath.h"
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
const string edgePerson = "person";
const string edgePersonActor = "person_actor";
const string edgePersonDirector = "person_director";
const string edgePersonCrew = "person_crew";



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
    void updateType(string t);
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
class EdgePerson: public Edge {
    
    // public
    public:
    
    // Node
    EdgePerson();
    EdgePerson(string ide, NodePtr n1, NodePtr n2);
};
