<?php 
	
	require_once 'inc/functions.php';
	reconnect_cookie(); // reconnexion automatique selon les cookies.

	// si le log est confirmé dans ce cas on redirige l'utilisateur vers account.
	if(isset($_SESSION['auth']))
	{
		header('Location : account.php');
		exit();
	}

	// si l'utilisateur a renseigné les champs ...
	if(!empty($_POST) && !empty($_POST['userName']) && !empty($_POST['password']))
	{
		require_once 'inc/db.php';
		
		// on vérifie la correspondance de son identifiant...
		$req = $pdo->prepare('SELECT * FROM users WHERE (userName = :userName OR eMail = :userName) AND confirmed_at IS NOT NULL');
		
		$req->execute(['userName' => $_POST['userName']]);
		$user = $req->fetch();

		// puis de son mot de passe avec la BDD.
		if(password_verify($_POST['password'], $user->password))
		{	
			$_SESSION['auth'] = $user;
			$_SESSION['flash']['success'] = "Félicitations, vous êtes connecté !";

			// creation du cookie.
			if($_POST['remember'])
			{
				$cookie_token = str_random(250);
				$pdo->prepare('UPDATE users SET cookie_token = ? WHERE id =?')->execute([$cookie_token, $user->id]);
				// attention à ce qu'on ne puisse pas deviner facilement ce cookie.
				// Ici j'ai concaténé plein d'info histoire que ça soit compliqué de deviner ce que sera cette clef
				// grâce à sha1 je crypte le tout pour rendre le cookie indéchiffrable.
				setcookie('remember',  $user->id. '=='.$cookie_token.sha1($user->id.'random_key'), time()*60*60*24*365);
			}

			// et je redirige.
			header('Location: account.php');
			exit();
		}
		// si le mot passe saisi ne correspond pas à celui associé au nom d'utilisateur,
		// on refuse l'accès.
		if(!password_verify($_POST['password'], $user->password))
		{
			$_SESSION['flash']['danger'] = "Identifiant ou mot de passe incorrect";
			header('Location: account.php');
		}
	
	}
	
	?>

	<?php require 'inc/header.php'; ?> 

	<h1>Se connecter</h1>

	<form action="" method="POST">
		<div class="form-group">
			<label for="">Pseudo ou eMail : </label> 
			<input type="text" name="userName" class="form-control" placeHolder="Entrez votre pseudo ou adresse mail ici"/>
		</div>

		<div class="form-group">
			<label for="">Mot de passe : </label>
			<input type="password" name="password" class="form-control" placeHolder="Entrer votre mot de passe ici"/>
			<a href="forget.php">(J'ai oublié mon mot de passe)</a>
		</div>
		<div class="form-group">
			<label>
				<input type="checkbox" name="remember" value="1"/>Se souvenir de moi.
			</label>
		</div>
		<button type="submit" class="btn btn-primary">Se connecter</button>
	</form>


<?php require 'inc/footer.php'; ?>	
