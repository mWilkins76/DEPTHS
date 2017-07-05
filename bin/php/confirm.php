<?php 
	
	// CONFIRMATION PAR MAIN
	// quand l'utilisateur clique sur le lien qui lui a été envoyé par mail.

	$user_id = $_GET['id']; // on récupère l'id dans le lien
	$token = $_GET['token']; // puis le token (clef)
	require 'inc/db.php';
	$req = $pdo->prepare('SELECT * FROM users WHERE id=?'); // on prépare la requette pour comparer l'ID
	$req ->execute([$user_id]); // on execute la requette.
	$user = $req->fetch(); // Récupère la ligne suivante d'un jeu de résultats PDO
	session_start();

	if($user && $user->confirmation_token == $token)
	{

		// et on fait la même chose pour le token contenu dans le lien.
		$pdo->prepare('UPDATE users SET confirmation_token = NULL, confirmed_at = NOW() WHERE id=?')->execute([$user_id]);
		$_SESSION['flash']['success'] = "Votre compte à bien été validé !";
		$_SESSION['auth'] = $user; // on authentifie l'user et on le redirige.
		header('Location:account.php');
	} 
	// empêche la double validation de compte.
	else
	{
		$_SESSION['flash']['danger'] = "Vous avez déjà validé votre compte";
		header('Location: login.php');
	}
