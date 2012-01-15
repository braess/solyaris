//
//  Graph.cpp
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

#include "Graph.h"


#pragma mark -
#pragma mark Object

/**
 * Creates a graph.
 */
Graph::Graph() {
}
Graph::Graph(int w, int h, int o) {
    
    // fields
    width = w;
    height = h;
    orientation = o;
    
    // virtual offset
    voff.set(0,0);
    vpoff.set(0,0);
    vmoff.set(0,0);
    mbound = 90.0;
    
    // virtual position
    vpos.set(0,0);
    vppos.set(0,0);
    
    // movement
    speed = 45;
    friction = 5.1;
    
    // hitarea
    harea = 15;
    
    // tooltip / action
    nbtouch = 10;
    for (int t = 1; t <= nbtouch; t++) {
        tooltips[t] = Tooltip(Vec2d(w,h));
        actions[t] = Action();
    }
    
    // layout
    layout_nodes = true;
    layout_subnodes = true;
    
    // zoom
    scale = 1.0;
    translate.set(0,0);
    
    // background
    background = gl::Texture(loadImage(loadResource("bg_graph.png")));
    
    // sample
    audioSampleClick = audio::load(loadResource(SAMPLE_CLICK));
}


#pragma mark -
#pragma mark Cinder

/**
 * Resize.
 */
void Graph::resize(int w, int h, int o) {
    
    // size
    width = w;
    height = h;
    
    // orientation
    orientation = o;
    
    
    // tooltip
    for (int t = 1; t <= nbtouch; t++) {
        tooltips[t].resize(w,h);
    }
    
}


/**
 * Applies the settings.
 */
void Graph::setting(GraphSettings s) {
    
    // reference
    gsettings = s;
    
    // layout nodes
    layout_nodes = true;
    Default graphLayoutNodes = s.getDefault(sGraphLayoutNodesDisabled);
    if (graphLayoutNodes.isSet()) {
        layout_nodes = ! graphLayoutNodes.boolVal();
    }
    
    // layout subnodes
    layout_subnodes = true;
    Default graphLayoutSubnodes = s.getDefault(sGraphLayoutSubnodesDisabled);
    if (graphLayoutSubnodes.isSet()) {
        layout_subnodes = ! graphLayoutSubnodes.boolVal();
    }
    
    
    // apply to nodes
    for (NodeIt node = nodes.begin(); node != nodes.end(); ++node) {
        (*node)->setting(gsettings);
    }
    
    // apply to edges
    for (EdgeIt edge = edges.begin(); edge != edges.end(); ++edge) {
        (*edge)->setting(gsettings);
    }
    
}


#pragma mark -
#pragma mark Sketch


/**
 * Updates the graph.
 */
void Graph::update() {
    

    // randomize
    Rand::randomize();
    
    // layout nodes
    if (layout_nodes) {
        
        // attract
        this->attract();
        
        // repulse
        this->repulse();
        
    }
    
    // layout subnodes
    if (layout_subnodes && ci::app::getElapsedFrames() % 6 == 0) {
        this->subnodes();
    }
    
    // virtual position
    Vec2d dd = vmpos - vpos;
    vppos = vpos;
    vpos += dd / friction;
    translate += (vpos - vppos);
    
    
    // virtual offset
    Vec2d dm = vmoff - voff;
    vpoff = voff;
    voff += dm/speed;
    Vec2d vmove = (voff - vpoff);
    
    
    // nodes
    for (NodeIt node = nodes.begin(); node != nodes.end(); ++node) {
        
        // active
        if ((*node)->isActive() || (*node)->isLoading()) {
            
            // global movement
            (*node)->move(vmove);
            
            // update
            (*node)->update();
            
            // node movement
            Vec2d ndist = (*node)->mpos - (*node)->pos;
            float nmov = (ndist.length() > 1) ? ndist.length() * 0.0045 : 0;

            // children
            for (NodeIt child = (*node)->children.begin(); child != (*node)->children.end(); ++child) {

                // move children
                if ((*node)->isNodeChild(*child)) {
                    
                    // follow
                    (*child)->translate((*node)->pos - (*node)->ppos);
                    
                    // randomize
                    (*child)->move(Rand::randFloat(-1,1)*nmov,Rand::randFloat(-1,1)*nmov);
                    
                    // update
                    (*child)->update();
                }
                
            }

        }
        
    }
    
    // edges
    for (EdgeIt edge = edges.begin(); edge != edges.end(); ++edge) {
        
        // active
        if ((*edge)->isVisible()) {
            (*edge)->update();
        }
    }
    
    // tooltip / actions
    for (int t = 1; t <= nbtouch; t++) {
        tooltips[t].update();
        actions[t].update();
    }

}

/**
 * Draws the graph.
 */
void Graph::draw() {
    
    
    // background
    gl::color( ColorA(1.0f, 1.0f, 1.0f, 1.0f) ); // alpha channel
    gl::draw(background);
    
    // push it
    gl::pushMatrices();
    gl::translate(translate);
    gl::scale(Vec2d(scale,scale));
    
    
    // edges
    for (EdgeIt edge = edges.begin(); edge != edges.end(); ++edge) {
        
        // draw if visible
        if ((*edge)->isVisible()) {
            (*edge)->draw();
        }
    }
    
    // nodes
    for (NodeIt node = nodes.begin(); node != nodes.end(); ++node) {
        
        // draw if visible and on stage
        if ((*node)->isVisible() && this->onStage(*node)) {
            (*node)->draw();
        }
    }
    
    // actions
    for (int t = 1; t <= nbtouch; t++) {
        actions[t].draw();
    }
    
    // pop
    gl::popMatrices();
    
    
    // tooltips
    for (int t = 1; t <= nbtouch; t++) {
        tooltips[t].draw();
    }

}


/**
 * Resets the graph.
 */
void Graph::reset() {
    DLog();
    
    // clear
    edges.clear(); 
    nodes.clear(); 
    
    // reset maps
    nmap.clear();
    emap.clear();
    
    // zoom
    scale = 1.0;
    translate.set(0,0);
    
}



#pragma mark -
#pragma mark Touch

/**
 * Touch.
 */
void Graph::touchBegan(Vec2d tpos, int tid) {
    GLog();
    
    // zoomed
    Vec2d ztpos = (tpos - translate)*(1.0/scale);
    
    // actions
    bool action = false;
    for (int t = 1; t <= nbtouch; t++) {
        if (actions[t].isActive()) {
            action = actions[t].action(ztpos);
        }
    }
    
    // nodes
    for (NodeIt node = nodes.begin(); ! action && node != nodes.end(); ++node) {
        
        // visible
        if ((*node)->isVisible()) {
            
            // distance
            float d = (*node)->pos.distance(ztpos);
            if (d < (*node)->core+harea) {
                
                // touched
                GLog("tid = %d, node = ",tid);
                touched[tid] = NodePtr(*node); 
                
                // state
                touched[tid]->touched();
                
                // set the tooltip
                this->tooltip(tid);
                tooltips[tid].position(tpos);
                
                // set the action
                this->action(tid);
                
                // sample
                this->sample(sampleClick);
                
                // have a break
                break;
                
            }
        }
    }

    
}
void Graph::touchMoved(Vec2d tpos, Vec2d ppos, int tid){
    GLog();

    // node
    if (touched[tid]) {
        GLog("tid = %d, node = ",tid);
        
        // zoom
        Vec2d ztpos = (tpos - translate)*(1.0/scale);
        
        // move
        touched[tid]->moveTo(ztpos);
        
        // tooltip
        tooltips[tid].position(tpos);


    }
    // graph
    else {
        
        // drag
        this->drag(tpos-ppos);
    }
    
}
void Graph::touchEnded(Vec2d tpos, int tid){
    GLog();
    
    // node
    if (touched[tid]) {
        
        // state
        GLog("tid = %d, node = ",tid);
        touched[tid]->untouched();
        
        // hide tooltip
        tooltips[tid].hide();
        
        // hide action
        actions[tid].hide();
    }
    // graph
    else {
        
        // undrag
        this->drag(Vec2d(0,0));
    }
    
    // reset
    touched.erase(tid);

}


#pragma mark -
#pragma mark Taps

/**
 * Tapped.
 */
NodePtr Graph::doubleTap(Vec2d tpos, int tid) {
    GLog();
    
    // zoom
    Vec2d ztpos = (tpos - translate)*(1.0/scale);
    
    // nodes
    for (NodeIt node = nodes.begin(); node != nodes.end(); ++node) {
        
        // visible
        if ((*node)->isVisible()) {
            
            // distance
            float d = (*node)->pos.distance(ztpos);
            if (d < (*node)->core+harea) {
                
                // tapped
                (*node)->tapped();
                
                // sample
                this->sample(sampleClick);
              
                // return
                return (*node);
            }
        }
    }
    
    // nop
    return NodePtr();
    
}



#pragma mark -
#pragma mark Gestures


/**
 * Pinched.
 * @url: http://www.gamedev.net/topic/560485-how-can-you-calculate-translation-while-zooming-in-with-zoom-gestures/
 */
void Graph::pinched(Vec2d p, Vec2d pp, double s, double ps) {
    GLog();
    
    // scale pinch point
    Vec2d pt = p;
    pt -= translate;
    pt *= (1.0/scale);
    
    // value
    double cs = s - ps;
    
    // scale
    scale += (cs*0.5);
    scale = min(scale, 1.3); 
    scale = max(scale, 0.3);
    
    // translate
    translate = -1 * (pt * scale - p); 
    
    // drag
    this->drag((p-pp) * scale);
    
}




#pragma mark -
#pragma mark Business


/**
 * Attraction.
 */
void Graph::attract() {
    
    // nodes
    for (NodeIt n1 = nodes.begin(); n1 != nodes.end(); ++n1) {
        
        // attract others
        for (NodeIt n2 = nodes.begin(); n2 != nodes.end(); ++n2) {
            if ((*n1)->isActive() && (*n2)->isActive() && ! (*n1)->isClosed() && ! (*n2)->isClosed() && (*n1) != (*n2)) {
                (*n1)->attract(*n2);
            }
        }
    }
    
}

/**
 * Repulsion.
 */
void Graph::repulse() {
    
    // edges
    for (EdgeIt edge = edges.begin(); edge != edges.end(); ++edge) {
        
        // active
        if ((*edge)->isActive()) {
            (*edge)->repulse();
        }
    }
    
}


/**
 * Subnodes.
 */
void Graph::subnodes() {
    
    // nodes
    for (NodeIt node = nodes.begin(); node != nodes.end(); ++node) {
        
        // active node on stage
        if ((*node)->isActive() && ! (*node)->isClosed() && ! (*node)->isLoading() && this->onStage(*node)) {
            
            // sphere
            float smin = (*node)->radius * nodeUnfoldMin;
            float smax = (*node)->radius * nodeUnfoldMax;
            
            // children
            for (NodeIt c1 = (*node)->children.begin(); c1 != (*node)->children.end(); ++c1) {
                
                // child
                if ((*node)->isNodeChild(*c1) && ! (*c1)->isSelected()) {
                    
                    // distract siblings
                    for (NodeIt c2 = (*node)->children.begin(); c2 != (*node)->children.end(); ++c2) {
                        if ((*node)->isNodeChild(*c2) && ! (*c2)->isSelected() && (*c1) != (*c2)) {
                            (*c1)->distract(*c2);
                        }
                    }
                    
                    // sphere repulsion
                    float dist = (*node)->pos.distance((*c1)->pos);
                    if (dist < smin) {
                        (*c1)->repulse((*node)->pos, smin, 1);
                    }
                    else if (dist > smax) {
                        (*c1)->repulse((*node)->pos, smax, -1);
                    }

                }
                
            }
            
        }
        

    }
    
}


/**
 * Move.
 */
void Graph::move(Vec2d d) {
    vmoff += d;
}

/**
 * Drag.
 */
void Graph::drag(Vec2d d) {
    
    // translate
    vmpos += d;
    
    // threshold
    float thresh = 1.0;
    if (abs(vmpos.x) < thresh && abs(vmpos.y) < thresh) {
        vmpos.set(0,0);
    }
}


/**
 * Creates a node.
 */
NodePtr Graph::createNode(string nid, string type) {
    GLog();
    
    // scale
    double sf = (1.0/scale);
    
    // position
    int b = 240*sf;
    Vec2d np = Vec2d( ((width*sf/2.0)-b + arc4random() % (2*b)), ((height*sf/2.0)-b + arc4random() % (2*b)) );
    
    // rezoom
    np -= translate*(1.0/scale);
    
    // create
    return createNode(nid,type,np.x,np.y);
}
NodePtr Graph::createNode(string nid, string type, double x, double y) {
    GLog();
    
    // node map
    nmap.insert(make_pair(nid, nodes.size()));
    
    // node
    if (type == nodeMovie) {
        boost::shared_ptr<NodeMovie> node(new NodeMovie(nid,x,y));
        node->sref = node;
        node->setting(gsettings);
        nodes.push_back(node);
        return node;
    }
    else if (type == nodePerson) {
        boost::shared_ptr<NodePerson> node(new NodePerson(nid,x,y));
        node->sref = node;
        node->setting(gsettings);
        nodes.push_back(node);
        return node;
    }
    else {
        boost::shared_ptr<Node> node(new Node(nid,x,y));
        node->sref = node;
        node->setting(gsettings);
        nodes.push_back(node);
        return node;
    }

}

/**
 * Gets a node.
 */
NodePtr Graph::getNode(string nid) {
    GLog();
    
    // find the key
    map<string,int>::iterator it = nmap.find(nid);
    if(it != nmap.end()) {
        return NodePtr(nodes.at(it->second));
    }
    
    // nop
    return NodePtr();
}


/**
 * Creates an edge.
 */
EdgePtr Graph::createEdge(string eid, string type, NodePtr n1, NodePtr n2) {
    GLog();
    
    // edge map
    emap.insert(make_pair(eid, edges.size()));
    
    // node
    if (type == edgeMovie) {
        boost::shared_ptr<Edge> edge(new EdgeMovie(eid,n1,n2));
        edge->setting(gsettings);
        edges.push_back(edge);
        return edge;
    }
    else if (type == edgePerson) {
        boost::shared_ptr<Edge> edge(new EdgePerson(eid,n1,n2));
        edge->setting(gsettings);
        edges.push_back(edge);
        return edge;
    }
    else {
        boost::shared_ptr<Edge> edge(new Edge(eid,n1,n2));
        edge->setting(gsettings);
        edges.push_back(edge);
        return edge;
    }

}

/**
 * Gets an edge.
 */
EdgePtr Graph::getEdge(string nid1, string nid2) {
    GLog();
    
    // find the key
    map<string,int>::iterator it1 = emap.find(nid1 + "_edge_" + nid2);
    if(it1 != emap.end()) {
        return EdgePtr(edges.at(it1->second));
    }
    map<string,int>::iterator it2 = emap.find(nid2 + "_edge_" + nid1);
    if(it2 != emap.end()) {
        return EdgePtr(edges.at(it2->second));
    }
    
    // nop
    return EdgePtr();
}

/**
 * Removes a node.
 */
void Graph::removeNode(string nid) {
    FLog();
    
    // erase from nodes
    int eraser = -1;
    int index = 0;
    for (NodeIt node = nodes.begin(); node != nodes.end(); ++node) {
        if ((*node)->nid == nid) {
            eraser = index;
        }
        index++;
    }
    if (eraser >= 0) {
        nodes.erase(nodes.begin()+eraser); 
    }
    
    // erase from map
    map<string,int>::iterator it = nmap.find(nid);
    if(it != nmap.end()) {
        nmap.erase(it);
    }
}


/**
 * Prepares the graph for loading.
 */
void Graph::load(NodePtr n) {
    FLog();
    
    // scale
    float sf = (1.0/scale);
    Vec2d p = (n)->mpos + (translate * sf);
    
    // bounds
    Vec2d d = Vec2d(0,0);
    if (p.x < mbound*sf) {
        d.x = mbound*sf - p.x;
    }
    else if (p.x > (width-mbound)*sf) {
        d.x = - (p.x - (width-mbound)*sf);
    }
    if (p.y < mbound*sf) {
        d.y = mbound*sf - p.y;
    }
    else if (p.y > (height-mbound)*sf) {
        d.y = - (p.y - (height-mbound)*sf);
    }
    
    // move it
    this->move(d);
}

/**
 * Unloads a node.
 */
void Graph::unload(NodePtr n) {
    FLog();
    
    // parent
    NodePtr pp = n->parent.lock();
    if (pp) {
        
        // unload
        n->unload();
    }
    else {
        this->removeNode(n->nid);
    }

}

/**
 * Indicates if a node is on stage.
 */
bool Graph::onStage(NodePtr n) {
    
    // scale
    float sf = (1.0/scale);
    Vec2d p = (n)->pos + (translate * sf);
    
    // borderline
    float b = 300;
    return p.x > -b*sf && p.x < (width+b)*sf && p.y > -b*sf && p.y < (height+b)*sf;
    
}


/**
 * Sets the tooltip.
 */
void Graph::tooltip(int tid) {
    GLog();
    
    // selected edges
    bool etouch;
    vector<string> txts = vector<string>();
    for (EdgeIt edge = edges.begin(); edge != edges.end(); ++edge) {
        
        // touched
        if ((*edge)->isTouched(touched[tid])) {
            etouch = true;
            txts.push_back((*edge)->info());
        }
    }
    
    // touched
    if (etouch && txts.size() > 0) {
        tooltips[tid].renderText(txts);
        tooltips[tid].offset(touched[tid]->radius+12.0);
        tooltips[tid].show();
    }
    
}

/**
 * Sets the action.
 */
void Graph::action(int tid) {
    GLog();
    
    // showtime
    if (touched[tid]->isActive() && ! touched[tid]->isClosed()) {
        actions[tid].assignNode(touched[tid]);
        actions[tid].show();
    }
    
}


/**
 * Sample player.
 */
void Graph::sample(int s) {
    
    // play it again sam
    switch(s) {
            // click
        case sampleClick:
            try {
                audio::Output::play(audioSampleClick);
            }
            catch (...) {
                // ignore
            }
            break;
        default:
            break;
    }

}


