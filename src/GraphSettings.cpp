//
//  GraphSettings.cpp
//  IMDG
//
//  Created by CNPP on 19.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#include "GraphSettings.h"


#pragma mark -
#pragma mark Settings Object

/**
 * GraphSettings.
 */
GraphSettings::GraphSettings() {
}



#pragma mark -
#pragma mark GraphSettings Accessors

/**
 * Set/get default.
 */
void GraphSettings::setDefault(string key, string value) {
   
    // add
    defaults.insert(make_pair(key, Default(key,value)));
}
Default GraphSettings::getDefault(string key) {
    
    // search
    map<string,Default>::iterator it = defaults.find(key);
    if(it != defaults.end()) {
        return it->second;
    }
    return Default();
}



#pragma mark -
#pragma mark Default Object

/**
 * Default.
 */
Default::Default() {
    set = false;
}
Default::Default(string k, string v) {
    
    // fields
    key = k;
    value = v;
    set = true;
}


#pragma mark -
#pragma mark Default Accessors

/**
 * Check.
 */
bool Default::isSet() {
    return set;
}

/**
 * Returns the value.
 */
string Default::stringVal() {
    return value;
}
int Default::intVal() {
    return boost::lexical_cast<int>(value);
}
float Default::floatVal() {
    return boost::lexical_cast<float>(value);
}
double Default::doubleVal() {
    return boost::lexical_cast<double>(value);
}
bool Default::boolVal() {
    return boost::lexical_cast<bool>(value);
}
