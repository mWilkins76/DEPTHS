<?php 

	function debug($variable)
	{
		echo '<pre>'.print_r($variable,true).'</pre>';
	}

	// tire une clef random de taille $lenght composée des caractères contenus dans $alaphabet
	function str_random($length)
	{
		$alphabet = "0123456789azertyuiopqsdfghjklmwxcvbnAZERTYUIOPQSDFGHJKLMWXCVBN";
		return substr(str_shuffle(str_repeat($alphabet,$length)),0, $length);
	}

	// protège les pages contre un accès d'utilisateur non loggés.
	// Exemple : un utilisateur non loggé qui tente d'accéder à la page mon compte.
	function check_access()
	{
		//session_status() est utilisée pour connaitre l'état de la session courante.
		//PHP_SESSION_NONE si les sessions sont activées, mais qu'aucune n'existe.
		if(session_status() == PHP_SESSION_NONE)
		{
	    	session_start();
	  	}

	  	// si l'utilisateur n'est pas loggé
		if (!isset($_SESSION['auth']))
		{
			$_SESSION['flash']['danger'] = "Identifiants incorrects ou compte non validé [Vous n'êtes pas loggés].";
			header('Location: login.php');
			exit();

		}

	}

	// fonction de reconnexion auto avec les cookies.
	function reconnect_cookie()
	{
		if(session_status() == PHP_SESSION_NONE)
		{
	    	session_start();
	  	}

		if(isset($_COOKIE['remember']) && !isset($_SESSION['auth']))
		{
			require_once 'db.php';

			if(!isset($pdo))
			{
				global $pdo;
			}
			

			$cookie_token = $_COOKIE['remember'];
			$parts = explode('==',$cookie_token);
			$user_id = $parts[0];
			$req = $pdo->prepare('SELECT * FROM users WHERE id = ?');
			$req->execute([$user_id]);
			$user = $req->fetch();

			if($user)
			{
				 $expected = $user_id. '=='.$user->cookie_token.sha1($user_id.'random_key');

				if($expected == $cookie_token)
				{
				 	session_start();
					$_SESSION['auth'] = $user;
					$_SESSION['flash']['success'] = "Félicitations, vous êtes connecté !";
					setcookie('remember',$cookie_token, time()*60*60*24*360);
				}
				else
				{
					setcookie('remember',null,-1);
				}
			}
			else
			{
				setcookie('remember',null,-1);
			}

		}
	}