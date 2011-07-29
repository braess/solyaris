<?php
require_once("_config.php");
    
// check request
if(isset($_GET['key']) && isset($_GET['id'])) {
    
    // movie
    $movie = array();
    
	// soak in the passed variable or set our own 
    $param_key = $_GET['key'];
    $param_id = $_GET['id'];
    
    // validate
    if (strcmp($param_key, $cfg['api.key']) == 0) {

    
        // connect to the db 
        $link = mysql_connect($cfg['db.host'],$cfg['db.user'],$cfg['db.pass']) or die('Cannot connect to the DB');
        mysql_select_db($cfg['db.name'],$link) or die('Cannot select the DB');

		// movie
		$movie['mid'] = $param_id;
		$query_movie = "SELECT * FROM movies WHERE movieid = '$param_id'";
        $rows_movie = mysql_query($query_movie,$link) or die('Errant query:  '.$query_movie);
		if(mysql_num_rows($rows_movie)) {
	
			 // row
			$row = mysql_fetch_assoc($rows_movie);
			
			// title
			$movie['title'] = formatTitle($row['title']);
			
			// year
			$movie['year'] = $row['year'];
		}

		// directors
		$directors = array();
        $query_directors = "SELECT * FROM directors,movies2directors WHERE directors.directorid = movies2directors.directorid AND movies2directors.movieid='$param_id'";
        $rows_directors = mysql_query($query_directors,$link) or die('Errant query:  '.$query_directors);
        if(mysql_num_rows($rows_directors)) {
	
			 // rows
			 while($row = mysql_fetch_assoc($rows_directors)) {
				
				// director
             	$director = array();

				// id
                $director['did'] = $row['directorid'];

				// name
                $director['name'] = formatName($row['name']);
				
				// addition
				$director['addition'] = $row['addition'];
				
				// assign
                $directors[] = $director;
          	}  
        }
		$movie['directors'] = $directors;
        
        // actors
		$actors = array();
        $query_actors = "SELECT * FROM actors,movies2actors WHERE actors.actorid = movies2actors.actorid AND movies2actors.movieid='$param_id'";
        $rows_actors = mysql_query($query_actors,$link) or die('Errant query:  '.$query_actors);
        if(mysql_num_rows($rows_actors)) {
	
			 // rows
			$i = 0;
			 while($row = mysql_fetch_assoc($rows_actors)) {
				
				// actor
             	$actor = array();

				// id
                $actor['aid'] = $row['actorid'];

				// name
				$actor['name'] = formatName($row['name']);

				// character
				$actor['character'] = formatCharacter($row['as_character']);
				
				// order
				$actor['order'] = formatOrder($row['as_character']);
				
				// assign
                $actors[] = $actor;
          	}  
        }
		$movie['actors'] = $actors;
		
    }
    
	// json
	header('Content-type: application/json');
    echo json_encode($movie);

    
	// disconnect
	@mysql_close($link);
}
?>