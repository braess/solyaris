<?php
    /**
     * Database.
     */
    $cfg['db.host'] = 'localhost'; 
    $cfg['db.name'] = 'imdg';
    $cfg['db.user'] = 'imdg'; 
    $cfg['db.pass'] = 'ZivDSG1Lig2p'; 
    
    /**
     * API.
     */
    $cfg['api.key'] = 'this-is-the-key-to-happiness'; 
	
	
	/**
	* Include movie.
	*/
	function includeMovie($title, $year) {
		
		// excludes
		$excs = array('Making of', 'Cast of', '(V)','(TV)','{','(VG)','(mini)');
		
		// title
		$inc = true;
		foreach ($excs as $exc) {
			if (stristr($title, $exc)) {
				$inc = false;
			}
		}
		
		// year
		if (! (strrpos($year, "?") === false)) {
			$inc = false;
		}
		
		return $inc;
	}
	
	/**
	* Format name.
	*/
	function formatName($name) {
		// name
		if (! (strrpos($name, ",") === false)) {
			$sep = strrpos($name, ",");
			$first = substr($name,$sep+2,strlen($name)-$sep);
			$last = substr($name,0,$sep);
			$name = $first . " " . $last; 
		}
		return $name;
	}
	
	/**
	* Format title.
	*/
	function formatTitle($title) {
		
		// year pattern
		$year_pattern = "/\([0-9]{4}\)/";
		
		// match
		preg_match($year_pattern, $title, $found);
		
		// replace
		$title = str_replace($found, "", $title);
		
		// remove special characters
		$title = str_replace("\"", "", $title);
		
		// the movie
		if (! (strrpos($title, ", The") === false)) {
			$sep = strrpos($title, ", The");
			$the = substr($title,$sep+2,strlen($title)-$sep);
			$movie = substr($title,0,$sep);
			$title = $the . $movie; 
		}
		
		// return
		return trim($title);
	}
	
	/**
	* Format character.
	*/
	function formatCharacter($character) {
		// character
		if (! (strrpos($character, "[") === false)) {
			$begin = strrpos($character, "[")+1;
			$end = strrpos($character, "]");
			$character = substr($character,$begin,$end-$begin);
		}
		return $character;
	}
	
	/**
	* Format order.
	*/
	function formatOrder($character) {
		// order
		$order = "1000"; // uncredited
		if (! (strrpos($character, "<") === false)) {
			$begin = strrpos($character, "<")+1;
			$end = strrpos($character, ">");
			$order = substr($character,$begin,$end-$begin);
		}
		return $order;
	}

?>