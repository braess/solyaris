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
	function includeMovie($title) {
		
		// excludes
		$excs = array('Making of', 'Cast of', '(V)','(TV)','{','(VG)','(mini)');
		
		// include
		$inc = true;
		foreach ($excs as $exc) {
			if (stristr($title, $exc)) {
				$inc = false;
			}
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