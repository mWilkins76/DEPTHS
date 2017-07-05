<?php 
	// Programme inspiré d'un tuto de GrafikArt => https://www.grafikart.fr/

	require_once 'inc/functions.php';

	session_start();

	// si les champs sont remplis
	if(!empty($_POST))
	{
		// gestion des erreurs dans un tableau.
		$errors = array();
		
		require_once 'inc/db.php';

		// si l'utilisateur n'a pas rempli son pseudo ou que les charactères se sont pas autorisés (preg_match)
		if(empty($_POST['userName']) || !preg_match('/^[a-zA-Z0-9_]+$/', $_POST['userName']))
		{
			$errors['userName'] = "Votre pseudo est incorrect.<br>Veuillez n'utiliser que des caractères alhpa-numériques (les underscores _ sont autorisés)";
		}
		else
		{
			// sinon on envoir le pseudo dans la base.
			$req = $pdo->prepare('SELECT id FROM users WHERE userName =?');
			$req-> execute([$_POST['userName']]);
			$user = $req->fetch();

			if($user) // si le nom d'utilisateur existe déjà dans la base
			{
				$errors['userName'] = 'Ce pseudo est déjà pris';
			}

		}

		// s'il n'a pas renseigné le champ email ou que le format d'email est invalide
		if(empty($_POST['eMail']) || !filter_var($_POST['eMail'], FILTER_VALIDATE_EMAIL))
		{
			$errors['eMail'] = "Votre eMail n'est pas valide";
		}
		else
		{
			// sinon on envoie l'email dans la BDD
			$req = $pdo->prepare('SELECT id FROM users WHERE eMail =?');
			$req->execute([$_POST['eMail']]);
			$user = $req->fetch();
			
			if($user)
			{
				$errors['eMail'] = "Cet eMail est déjà utilisé pour un autre compte";
			}

		}

		// idem pour les mots de passe + on vérifie qu'ils concordent
		if(empty($_POST['password']) || $_POST['password'] != $_POST['password_confirm'])
		{
			$errors['password'] = "Votre mot de passe n'est pas valide";
		}

		// SI LE TABLEAU D'ERREURS EST VIDE ...
		if(empty($errors))
		{

			// on prépare la requette
			$req = $pdo->prepare('INSERT INTO users SET userName = ?, password = ?, eMail = ?, confirmation_token = ?');

			// on crypte le mot de passe
			$password = password_hash($_POST['password'],PASSWORD_BCRYPT);
			
			// on génére un token
			$token = str_random(60);			

			// et on fourre le tout dans la BDD gentillement
			$req->execute([$_POST['userName'], $password, $_POST['eMail'], $token]);
			
			$user_id = $pdo->lastInsertId(); //(Ceci récupère le dernier ID enregitré dans la BDD)

			// envoie du mail de confirmation et d'activation
			mail($_POST['eMail'], 'monSite.com - Activation de votre compte', "Afin de valider votre compte, merci de cliquer sur ce lien\n\nhttp://localhost/GestionUser/confirm.php?id=$user_id&token=$token");
			
			$_SESSION['flash']['success'] = "Un eMail de confirmation vous a été envoyé pour valider votre compte.";

			header('location:login.php');
			exit();


		}
	}

?>

	

	<?php require 'inc/header.php'; ?>
	
	<h1>S'inscrire</h1>

	
	<?php 

	// SI LE TABLEAU D'ERREURS EN CONTIENT
	// on fait un foreach dans le tableau et on affiche à l'écran le type d'erreur.
	if(!empty($errors)): ?>
	<div class="alert alert-danger">
		
		<p>Vous n'avez pas rempli le formulaire correctement</p>

		<ul>
			<?php foreach($errors as $error): ?>

				<li><?=$error; // le <?= c'est un raccourcit pour faire un echo ?></li>

			<?php endforeach; ?>
		</ul>
	</div>
	<?php endif;?>
	

	<form action="" method="POST">
		<div class="form-group">
			<label for="">Pseudo : </label> 
			<input type="text" name="userName" class="form-control" placeHolder="Entrez votre pseudo ici"/>
		</div>
		<div class="form-group">
			<label for="">Email : </label>
			<input type="text" name="eMail" class="form-control" placeHolder="Entrez votre adresse mail ici"/>
		</div>
		<div class="form-group">
			<label for="">Mot de passe : </label>
			<input type="password" name="password" class="form-control" placeHolder="Choisissez votre mot de passe"/>
		</div>
		<div class="form-group">
			<label for="">Confirmation du mot de passe : </label>
			<input type="password" name="password_confirm" class="form-control" placeHolder="Confirmez votre mot de passe"/>
		</div>
		<button type="submit" class="btn btn-primary">M'inscrire</button>
	</form>



<?php require 'inc/footer.php'; ?>