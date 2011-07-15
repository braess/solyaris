<?php
require_once("_config.php");
    
// check request
if(isset($_GET['key']) && isset($_GET['id'])) {
    
    // director
    $director = array();
    
	// soak in the passed variable or set our own 
    $param_key = $_GET['key'];
    $param_id = $_GET['id'];
    
    // validate
    if (strcmp($param_key, $cfg['api.key']) == 0) {

    
        // connect to the db 
        $link = mysql_connect($cfg['db.host'],$cfg['db.user'],$cfg['db.pass']) or die('Cannot connect to the DB');
        mysql_select_db($cfg['db.name'],$link) or die('Cannot select the DB');

		// director
		$director['did'] = $param_id;
		$query_director = "SELECT name FROM directors WHERE directorid = '$param_id'";
        $row_director = mysql_query($query_director,$link) or die('Errant query:  '.$query_director);
        $name = mysql_result($row_director, 0);

		// name
		$director['name'] = formatName($name);
		 
		// movies
		$movies = array();
		$query_movies = "SELECT * FROM movies,movies2directors WHERE movies.movieid = movies2directors.movieid AND movies2directors.directorid='$param_id'";
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

					// assign
					$movies[] = $movie;
				}

          	}  
        }
		$director['movies'] = $movies;
		
    }
    
	// json
	header('Content-type: application/json');
    echo json_encode($director);

	// disconnect
	@mysql_close($link);
}
?>