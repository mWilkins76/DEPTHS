<?php 

	require 'inc/functions.php';
	
	check_access(); // vérification de l'authentification du log de l'utilisateur

	// MODIFICATION DU MOT DE PASSE

	if(!empty($_POST))
	{
		// si l'utilisateur n'à  pas rempli le ou les champs et que les mots de passes ne concordent pas :
		if(empty($_POST['password']) || ($_POST['password'] != $_POST['password_confirm']))
		{
			$_SESSION['flash']['danger'] = "Les mots de passes ne correspondent pas ou ne sont pas valides.";
		}
		// si tout est ok, on encrypte le nouveau mot de passe et l'enregistre dans la BDD
		else
		{
			$user_id = $_SESSION['auth']->id;
			$password = password_hash($_POST['password'], PASSWORD_BCRYPT);
			require_once 'inc/db.php';
			$pdo->prepare('UPDATE users SET password=? WHERE id=?')->execute([$password,$user_id]);
			$_SESSION['flash']['success'] = "Votre mot de passe a bien été mis à jours.";
		}

	}


	require 'inc/header.php';
	
?>

	<h1>Votre Compte:</h1>
	<h4>Bonjour <?php echo($_SESSION['auth']->userName); ?></h4>
	<p>votre adresse mail est : <?php echo($_SESSION['auth']->eMail); ?></p>

	<p>Vous pouvez modifier ici les informations concernant votre compte : </p>


	<form action="" method="POST">

	<h3>Modifier votre mot de passe : </h3>	
		<div class="form-group">
			<input class="form-control" type="password" name="password" placeholder="Entrez votre nouveau mot de passe">
		</div>
		<div class="form-group">
			<input class="form-control" type="password" name="password_confirm" placeholder="Confirmez votre nouveau mot de passe">
		</div>
		<button class="btn btn-primary">Valider</button>
	</form>

<?php require 'inc/footer.php'; ?>	




