//
//  Edge.h
//  IMDG
//
//  Created by CNPP on 22.5.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#pragma once
#include "Node.h"
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


/**
 * Graph Edge.
 */
class Edge {
    
    
    // public
    public:
    
    // Edge
    Edge();
    Edge(NodePtr n1, NodePtr n2); 
    
    // Sketch
    void update();
    void draw();
    
    // Business
    void repulse();
    void hide();
    void show();
    bool isActive();
    bool isVisible();
    void dealloc();
    
    // Public Fields
    NodePtr node1;
    NodePtr node2;
    
    
    // private
    private:
    
    // States
    bool active;
    bool visible;
    
    // parameters
    double length;
    double stiffness;
    double damping;
    
    // color
    Color cstroke;
};