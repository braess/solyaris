<?php
require_once("_config.php");
    
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

		// query term
		$qt = "";
		$terms = explode(" ",$param_query);
		foreach($terms as $t) {
			$qt .= "+$t ";
		}
        
        // query
        $query;
        switch ($param_type) {
            case "movie":
				$query = "SELECT * FROM movies WHERE title LIKE '%$param_query%' ORDER BY title LIMIT 100";
                break;
            case "actor":
				$query = "SELECT * FROM actors WHERE MATCH (name) AGAINST ('$qt' IN BOOLEAN MODE) ORDER BY name LIMIT 100";
                break;
            case "director":
				$query = "SELECT * FROM directors WHERE MATCH (name) AGAINST ('$qt' IN BOOLEAN MODE) ORDER BY name LIMIT 100";
                break;
        }
        
        // query 
        $rows = mysql_query($query,$link) or die('Errant query:  '.$query);
        
        // results
        if(mysql_num_rows($rows)) {
            switch ($param_type) {
				
				// movie
                case "movie":

					// rows
                    while($row = mysql_fetch_assoc($rows)) {
				
						// result
						if (includeMovie($row['title'],$row['year'])) {
							$result = array();
	                        $result['rid'] = $row['movieid'];
	                        $result['data'] = formatTitle($row['title']);
	                        $results[] = $result;
						}
                    }
                    break;

				// actor
                case "actor":

					// rows
                    while($row = mysql_fetch_assoc($rows)) {
						
						// result
                        $result = array();
                        $result['rid'] = $row['actorid'];
                        $result['data'] = $row['name'];
                        $results[] = $result;
                    }
                    break;

				// director
                case "director":
					
					// rows
                    while($row = mysql_fetch_assoc($rows)) {
						
						// result
                        $result = array();
                        $result['rid'] = $row['directorid'];
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