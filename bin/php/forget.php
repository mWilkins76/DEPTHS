<?php 

	// (RECUPERATION ... ou ici) RE-INITIALISATION DE MOT DE PASSE 

	require 'inc/header.php';

	

	// Si l'utilisateur à bien rempli le champ Email :
	if(!empty($_POST) && !empty($_POST['eMail']))
	{
		require_once 'inc/db.php';
		require_once 'inc/functions.php';
		// le confirmed_at dans la requette vérifie que les utilisateurs on bien validé leur compte par mail.
		$req = $pdo->prepare('SELECT * FROM users WHERE eMail = ? AND confirmed_at IS NOT NULL');
		$req->execute([$_POST['eMail']]);
		$user = $req->fetch();

		if($user) // si l'utilisateur existe
		{	
			// on crée une clef token de 60 charactères
			$reset_token = str_random(60);
			// on envoie dans la BDD le token et la date de reset.
			$pdo->prepare('UPDATE users SET reset_token = ?, reset_at = NOW() WHERE id=?')-> execute([$reset_token,$user->id]);
			$_SESSION['flash']['success'] = "Les instructions de récupération de mot de passe viennent de vous être envoyées par eMail.";
			// on envoie un mail de récupération
			mail($_POST['eMail'], 'monSite.com - Ré-initialisation de votre mot de passe', "Afin de ré_initialiser votre mot de passe, merci de cliquer sur ce lien\n\nhttp://localhost/GestionUser/reset.php?id={$user->id}&token=$reset_token");
			
			header('Location: login.php');
			exit();
		}
		
		else
		{
			$_SESSION['flash']['danger'] = "Aucun compte ne correspond à cet EMAIL.";
		}
	
	}
?>

	<h1>Récupération de votre mot de passe : </h1>

	<form action="" method="POST">
		<div class="form-group">
			<label for="">Votre EMail : </label> 
			<input type="email" name="eMail" class="form-control" placeHolder="Entrez votre adresse mail ici"/>
		</div>

		<button type="submit" class="btn btn-primary">Se connecter</button>
	</form>


<?php require 'inc/footer.php'; ?>	