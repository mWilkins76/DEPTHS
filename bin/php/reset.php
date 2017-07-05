<?php 

	if(isset($_GET['id']) && isset($_GET['token']))
	{
		require 'inc/db.php';
		require 'inc/functions.php';

		$req = $pdo->prepare('SELECT * FROM users WHERE id = ? AND reset_token = ? AND reset_token IS NOT NULL AND reset_at > DATE_SUB(NOW(), INTERVAL 30 MINUTE)');
		$req->execute([$_GET['id'], $_GET['token']]);
		$user=$req->fetch();

			if(!$user) //Si l'utilisateur n'est pas loggé
			{
				// et que les mots de passes concordent.
				if(!empty($_POST['password']) && $_POST['password'] == $_POST['password_confirm'])
				{
					// redéfinition et cryptage du mot de passe.
					$password = password_hash($_POST['password'],PASSWORD_BCRYPT);
					$pdo->prepare('UPDATE users SET password = ?')->execute([$password]);
					session_start();
					$_SESSION['flash']['success'] = "Votre mot de passe a bien été modifié";
					header('Location:login.php');
					exit();
				}	
				

			}
			else
			{
				session_start();
				$_SESSION['flash']['danger'] = "Ce Token n'est pas valide.";
				echo("non valide");
				header('Location: login.php');
				exit();
			}
	}
	else
	{


		header('Location login.php');
		exit();
		
	}

	
?>

	<?php require 'inc/header.php'; ?> 

	<h1>RéInitialisez votre mot de passe</h1>

	<form action="" method="POST">
		<div class="form-group">
			<label for="">Nouveau mot de passe : </label> 
			<input type="text" name="password" class="form-control"/>
		</div>

		<div class="form-group">
			<label for="">Confirmez votre nouveau mot de passe: </label>
			<input type="password" name="password_confirm" class="form-control" />
		</div>

		<button type="submit" class="btn btn-primary">Valider</button>
	</form>


<?php require 'inc/footer.php'; ?>	
