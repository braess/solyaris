<?php
require_once("config.php");
    
// check request
if(isset($_GET['key']) && isset($_GET['query'])) {
    
    // results
    $results = array();
    
	// soak in the passed variable or set our own 
    $param_key = $_GET['key'];
    $param_query = $_GET['query'];
	$param_type = isset($_GET['type']) ? $_GET['type'] : 'movie'; 
    
    // validate
    if (strcmp($param_key, $cfg['api.key']) == 0) {

    
        // connect to the db 
        $link = mysql_connect($cfg['db.host'],$cfg['db.user'],$cfg['db.pass']) or die('Cannot connect to the DB');
        mysql_select_db($cfg['db.name'],$link) or die('Cannot select the DB');
        
        // query
        $query;
        switch ($param_type) {
            case "movie":
                $query = "SELECT * FROM movies WHERE title LIKE '%$param_query%' ORDER BY title LIMIT 100";
                break;
            case "actor":
                $query = "SELECT * FROM actors WHERE name LIKE '%$param_query%' ORDER BY name LIMIT 100";
                break;
            case "director":
                $query = "SELECT * FROM directors WHERE name LIKE '%$param_query%' ORDER BY name LIMIT 100";
                break;
        }
        
        // query 
        $rows = mysql_query($query,$link) or die('Errant query:  '.$query);
        
        // create one master array of the records
        if(mysql_num_rows($rows)) {
            switch ($param_type) {
                case "movie":
                    while($row = mysql_fetch_assoc($rows)) {
                        $result = array();
                        $result['did'] = $row['movieid'];
                        $result['data'] = $row['title'];
                        $results[] = $result;
                    }
                    break;
                case "actor":
                    while($row = mysql_fetch_assoc($rows)) {
                        $result = array();
                        $result['did'] = $row['actorid'];
                        $result['data'] = $row['name'];
                        $results[] = $result;
                    }
                    break;
                case "director":
                    while($row = mysql_fetch_assoc($rows)) {
                        $result = array();
                        $result['did'] = $row['directorid'];
                        $result['data'] = $row['name'];
                        $results[] = $result;
                    }
                    break;
            }
        }
    }
    
	// json
	header('Content-type: application/json');
    echo json_encode(array('result'=>$results));

    
	// disconnect
	@mysql_close($link);
}
?>