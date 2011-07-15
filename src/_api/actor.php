<?php
require_once("_config.php");
    
// check request
if(isset($_GET['key']) && isset($_GET['id'])) {
    
    // actor
    $actor = array();
    
	// soak in the passed variable or set our own 
    $param_key = $_GET['key'];
    $param_id = $_GET['id'];
    
    // validate
    if (strcmp($param_key, $cfg['api.key']) == 0) {

    
        // connect to the db 
        $link = mysql_connect($cfg['db.host'],$cfg['db.user'],$cfg['db.pass']) or die('Cannot connect to the DB');
        mysql_select_db($cfg['db.name'],$link) or die('Cannot select the DB');

		// actor
		$actor['aid'] = $param_id;
		$query_actor = "SELECT name FROM actors WHERE actorid = '$param_id'";
        $row_actor = mysql_query($query_actor,$link) or die('Errant query:  '.$query_actor);
        $name = mysql_result($row_actor, 0);

		// name
		$actor['name'] = formatName($name);
		 
		// movies
		$movies = array();
		$query_movies = "SELECT * FROM movies,movies2actors WHERE movies.movieid = movies2actors.movieid AND movies2actors.actorid='$param_id'";
        $rows_movies = mysql_query($query_movies,$link) or die('Errant query:  '.$rows_movies);
        if(mysql_num_rows($rows_movies)) {
	
			 // rows
			 while($row = mysql_fetch_assoc($rows_movies)) {
				
				// result
				if (includeMovie($row['title'])) {
					
					// movie
	             	$movie = array();

					// id
	                $movie['mid'] = $row['movieid'];
	
					// title
					$movie['title'] = $row['title'];
					
					// year
					$movie['year'] = $row['year'];
					
					// character
					$movie['character'] = formatCharacter($row['as_character']);
					
					// order
					$movie['order'] = formatOrder($row['as_character']);

					// assign
					$movies[] = $movie;
				}

          	}  
        }
		$actor['movies'] = $movies;
		
    }
    
	// json
	header('Content-type: application/json');
    echo json_encode($actor);

	// disconnect
	@mysql_close($link);
}
?>