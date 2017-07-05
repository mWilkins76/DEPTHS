<?php
error_reporting(E_ALL);
ini_set("display_errors", 1);
header('Content-Type: application/json');
session_start();
date_default_timezone_set('UTC');

require "vendor/autoload.php";
include("acces.php");
include("gameBalance/startPlayerInfo.php");

	//case connexion
	//si ça marche pas décommente en dessous
	//use Facebook/Facebook;

//reste a faire : changer les $GLOBAL en global en passant les variable dans le scope general
//try catch juste sur les appel pdo
//créer un class playerData au lieu de stdClass

//code D'erreur :
$retour = "0000 : unknow error";
$error_connect_BDD = " 0001 : Error database connection : ";
$error_player_NotFound = "0002 : Player doesnt exist : ";
$error_bat_type_not_found = "0003 : Unknow building type ";
$error_create_player = "0004 : Error create player : ";
$error_get_player = "0004 : Error get player : ";
$error_create_building = "0005 : Error create building : ";
$error_fbGraph = "0006 : Graph return an error : ";
$error_fbSdk = "0007 : Graph returned an error : ";
$error_noaction = "0008 : Error no actions to do on data base !";
$error_getBuildings = "0009 : Error get buildings : ";
$error_building_changePos = "0010 : Error change building position : ";
$error_destroy_building = "0011 : Error destroy building : ";
$error_mode_building = "0012 : Error change building mode : ";
/*$error_mode_building = "0013 : Error region mode : ";*/
$error_not_enough_value = "0014 : Error not enough value ";
$error_get_value_player = "0015 : Error could not get player value ";
$error_change_value_player = "0016 : Error could not change player value ";
$error_get_regions = "0017 : Error get regions ";
$error_add_region = "0018 : Error add regions ";
$error_endtime_building = "0019 : Error change endTime Building : ";
$error_getDestructible = "0020 : Error get destructable element : ";
$error_changeFTUEstep = "0021 : Error change Step of FTUE";
$error_destroy_destructible = "0022 : Error destroy destructable : ";
$error_mode_destructible = "0023 : Error change destructable mode: ";
$error_create_destructible = "0024 : Error create destructable: ";
$error_dest_type_not_found = "0025 : Unknow destructable type ";
$error_schema = "0026 : Error Schema DB ";
$error_playerSchemas = "0026 : Error Schema Player DB ";
$error_time = "0027 : Error Time Server";
$error_xp = "0028 : Error xp";
$error_getAlien = " 0029 : Error get aliens";
$error_getbuffer = "0030 : Error get aliens buffers";
$error_getprod = "0031 : Error get aliens producers";
$error_getesth = "0032 : Error get aliens esthetiques";
$error_getspefeat = "0033 : Error get aliens spé feature";
$error_addAlien = "0034 : Error add alien";
$error_building_level = "0035 : Error building level";
$error_update_gene = "0036 : Error udpate gene";
$error_mode_alien = "0037 : Error mode alien";
$error_addSchema = "0038 : Error add Schema - pas de bol";
$error_unlockSchema = "0039 : Error unlock Schema - pas cool du tout du tout";
$error_change_ID_alien = "0040 : Error changing idBuilding of alien";
$error_schema_type_not_found = "0666 : Error de l'enfer sur le type de schéma";
$error_schema_decryptTime_not_found = "0666bis : Error sur le temps de Decrypt";
$error_start_unlock = "999 :error start decrypt";

$fb = new Facebook\Facebook([
	'app_id' => '1007819322696165',
	'app_secret' => 'c2a674070e84a13f90dc9b93d75d0120',
	'default_graph_version' => 'v2.8',
	]);

$helper = $fb->getJavascriptHelper();

if(!isset($_SESSION['token']))
{
	try
	{
		$accessToken = $helper->getAccessToken();
		$_SESSION['token'] = $accessToken;
	} 
	catch (Facebook\Exceptions\FacebookResponseException $e) 
	{
		$GLOBALS['retour'] = $GLOBALS["error_fbGraph"]." : ".$e-> getMessage();
		endScript();
		exit;
	}
	catch (Facebook\Exceptions\FacebookSDKException $e) 
	{
		$GLOBALS['retour'] = $GLOBALS["error_fbSdk"]." : ".$e-> getMessage();
		endScript();
		exit;
	}
}

//différente actions sur la BDD
$action = $_GET['action'];
if (!empty($action))
{
	$bdd = connexionBDD();
	switch($action) {
	
		case "connexion":
			isPlayerExist($_POST['data'], $_POST['name']);
			break;
		case "getBuildings":
			getPlayerBuildings($_POST['data']);
		break;
		case "addBuilding":
			addbuilding($_POST['type'], $_POST['playerID'], $_POST['regionX'], $_POST['regionY'], $_POST['x'], $_POST['y'], $_POST['globalX'], $_POST['globalY'], $_POST['layer'],$_POST["buildingID"]);
		break;	
		case "releaseBuildingPosition":
            releaseBuildingPosition($_POST['id'],$_POST['idPlayer'], $_POST['regionX'], $_POST['regionY'], $_POST['x'], $_POST['y']);
        break;                
        case "destroyBuilding":	
            destroyBuilding($_POST['id'],$_POST['idPlayer']);
		break;
		case "releaseBuildingMode" :	
			releaseBuildingMode($_POST['id'], $_POST['idPlayer'], $_POST['mode']);
		break;
		case "addRegion":	
			addRegion($_POST['idPlayer'],$_POST['x'],$_POST['y']);
		break;
		case "getRegions":		
			getRegions($_POST['data']);
		break;
        case "checkValue":		
            checkPlayerValue($_POST['idPlayer'], $_POST['value'], $_POST['typeValue']);
        break;
        case "changeEndTimeBuilding":
        	changeEndTimeBuilding($_POST['id'], $_POST['endTime']);
        break;
        case "changeEnergy":
        	changeEnergy($_POST['idPlayer'], $_POST['value']);
        break;
        case "changeMaxEnergy":
        	changeMaxEnergy($_POST['idPlayer'], $_POST['value']);
        break;
        case "ftueNewStep":
        	changeFtueStep($_POST['idPlayer'], $_POST['value']);
        break;
		case "releaseDestructibleMode":
			releaseDestructibleMode($_POST['id'], $_POST['idPlayer'], $_POST['mode'], $_POST['name']);
			break;
		case "destroyDestructible":
			destroyDestructible($_POST['id'], $_POST['idPlayer']);
			break;
		case "addDestructible":
			addDestructable($_POST['type'], $_POST['playerID'], $_POST['regionX'], $_POST['regionY'], $_POST['x'], $_POST['y'], $_POST['layer'], $_POST['destructableID']);
			break;
		case "time":
			getTime();
			break;
		case "changeXpLevel":
			changeXpLevel($_POST['playerID'], $_POST['xp'], $_POST['level']);
			break;
		case "changeBuildingLevel":
			changeBuildingLevel($_POST['id'], $_POST['playerID'], $_POST['level']);
			break;
		case "addAlien":
			addAlien($_POST['playerID'], $_POST['buildingID'], $_POST['alienID'],  $_POST['type'],  $_POST['name'],  $_POST['nomPropre'],  $_POST['stamina'],  $_POST['time']);
			break;
		case "changeAlienIdBuilding":
			changeAlienIdBuilding($_POST['buildingID'], $_POST['alienID']);
			break;
		case "updateGene":
			updateGene($_POST['playerID'], $_POST['gene1'], $_POST['gene2'],  $_POST['gene3'],  $_POST['gene4'],  $_POST['gene5']);
			break;
		case "modeAlien":
			releaseAlienMode($_POST['alienId'], $_POST['idPlayer'], $_POST['mode'], $_POST['timeEnd']);
			break;
		case "getFriendAlien":
			getFriendsAlien($_POST['friendsList']);
			break;
		case "getFriends":
			getFriends($_POST['friendsList']);
			break;
		case "addSchema":
			addPlayerSchema($_POST['playerID'], $_POST['schemaID']);
			break;
		case "unlockSchema":
			unlockSchema($_POST['playerID'], $_POST['schemaID']);
			break;
		case "getSchemaTimeToDecrypt":
			getSchemaTimeToDecrypt($_POST['schemaID']);
			break;
		case "startUnlockSchema":
			startUnlockSchema($_POST['playerID'], $_POST['schemaID'], $_POST['start'], $_POST['end']);
			break;
        default : echo json_encode("error 404 default");
	}
}
else 
{
	$GLOBALS['retour'] = $GLOBALS["error_noaction"];
	endScript();
}

//BDD
function connexionBDD()
{
	try
	{
		$bdd = new PDO($GLOBALS['host'], $GLOBALS['login'], $GLOBALS['pass']);
		$bdd->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
		$bdd->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_OBJ);
		return $bdd;		
	}
	catch(Exception $e)
	{
		$GLOBALS['retour'] = $GLOBALS["error_connect_bdd"].$e-> getMessage();
		endScript();
	}
}


	//player
function isPlayerExist($idFB, $name)
{
	$playerInfo;
	$regionData;
	$buildings;
	$firstTime = false;
	try
	{
		$reqGet = 'SELECT * FROM player WHERE idFb = ?';
		$reqPrepared = $GLOBALS['bdd']->prepare($reqGet);
		if($reqPrepared->execute(array($idFB)))
		{
			$result = $reqPrepared->fetch();
			if (!$result)
			{
				$playerInfo = createUser($idFB, $name);
				$regionData = "";
				addbuilding("UrbanHeadQuarter", $playerInfo->id, 0, 0, 7, 7, 0, 700	, 1, "UrbanHeadQuarter0000000", true, "Wait");
				addDestructable("DestructibleSkeleton", $playerInfo->id, 0, 0, 15, 15, 1, "DestructibleSkeleton0000001");
				$firstTime = true;
			}
			else 
			{
				$playerInfo = $result;
				$regionData = getRegions((int)$result->id);
			}
			
			//if($playerInfo->dateConnexion != getTime())
			
		}
	}
	catch(Exception $e)
	{
		$GLOBALS['retour'] = $GLOBALS['error_create_player'].$e-> getMessage();
		endScript();		
	}
	//$buildingTypes = getBuildingTypes(); liste de buildingsType complete
	$buildings = getPlayerBuildings($playerInfo->id);
	$buildingTypes = getBuildingTypes();
	$destructableTypes = getDestructableTypes();
	$destructable = getPlayerDestructable($playerInfo->id);
	$playerSchemas = getPlayerSchemas($playerInfo->id);
	$schema = getSchema();
	$bufferTypes = getBufferTypes();
	$prodTypes = getProdTypes();
	$esthTypes = getEsthTypes();
	$speFeatTypes = getSpeFeatTypes();
	$aliens = getAliens($playerInfo->id);
	
	$playerData = new stdClass();
	$playerData -> { "playerInfo" } = $playerInfo;
	$playerData -> { "region" } = $regionData;
	$playerData -> { "destructable" } = $destructable;
	$playerData -> { "buildings" } = $buildings;
	$playerData -> { "buildingTypes" } = $buildingTypes;
	$playerData -> { "destructableTypes" } = $destructableTypes;
	$playerData -> { "playerSchemas" } = $playerSchemas;
	$playerData -> { "schemaXenos" } = $schema;
	$playerData -> { "bufferTypes" } = $bufferTypes;
	$playerData -> { "producerTypes" } = $prodTypes;
	$playerData -> { "esthetiqueTypes" } = $esthTypes;
	$playerData -> { "speFeatTypes" } = $speFeatTypes;
	$playerData -> { "aliens" } = $aliens;
	
	$playerData -> { "firstTime" } = $firstTime;
	echo json_encode($playerData);
}

function getSchema()
{
	$req = 'SELECT * FROM schemasXenos';
	
	try
	{	$reqPrepared = $GLOBALS['bdd']->prepare($req);
		$reqPrepared->execute();
		$result = $reqPrepared->fetchAll();

	}
	catch(Exception $e)	
	{
		$GLOBALS['retour'] = $GLOBALS['error_schema'].$e-> getMessage();
		endScript();
	}
	
	return $result;
}



function getPlayerSchemas($idPlayer)
{
	$req = 'SELECT * FROM playerSchemas WHERE idPlayer = ?';
	
	try
	{	
		$reqPrepared = $GLOBALS['bdd']->prepare($req);		
		if($reqPrepared->execute(array($idPlayer)))
		{
			$allResult = $reqPrepared->fetchALL();
			return $allResult;
		}	

	}
	catch(Exception $e)	
	{
		$GLOBALS['retour'] = $GLOBALS['error_playerSchemas'].$e-> getMessage();
		endScript();
	}
	
	return $result;
}

function addPlayerSchema($playerID, $schemaID)
{
	try
	{	
		$reqCreate = 'INSERT INTO playerSchemas (idPlayer, idSchema, isLocked) VALUES (:pPlayerID, :pSchemaID, 1)';
		$reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);
		
		$reqPrepare->bindParam(':pPlayerID',$pPlayerId);
		$reqPrepare->bindParam(':pSchemaID',$pSchemaID);
	
		$pPlayerId = $playerID;	
		$pSchemaID = $schemaID;	

		$reqPrepare->execute();
	}
	catch(Exception $e)	
	{
		$GLOBALS['retour'] = $GLOBALS['error_addSchema'].$e-> getMessage();
		endScript();
	}		

}

function unlockSchema($playerID, $schemaID)
{
	
	try
	{	
		$reqCreate = 'UPDATE playerSchemas SET isLocked = 0, startDecrypt = NOW() WHERE  idPlayer = :pIdPlayer AND idSchema = :pSchemaID';
		$reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);
		
		$reqPrepare->bindParam(':pIdPlayer',$pPlayerId);
		$reqPrepare->bindParam(':pSchemaID',$pSchemaID);
	
		$pPlayerId = $playerID;	
		$pSchemaID = $schemaID;

		$reqPrepare->execute();
	}
	catch(Exception $e)	
	{
		$GLOBALS['retour'] = $GLOBALS['error_startDecryptSchema'].$e-> getMessage();
		endScript();
	}	

}

function getSchemaTimeToDecrypt($schemaID)
{

	try
	{		
		$req = 'SELECT decryptTime FROM schemasXenos WHERE id = ?';
		$reqPrepared = $GLOBALS['bdd']->prepare($req);		
		
		if($reqPrepared->execute(array($schemaID)))
		{
			$result = $reqPrepared->fetch();
			 echo json_encode($result);
		}				
	}
	catch(Exception $e)	
	{
		$GLOBALS['retour'] = $GLOBALS['error_schema_decryptTime_not_found'].$e-> getMessage();
		endScript();
	}
}

function startUnlockSchema($playerID, $schemaID, $start, $end)
{
	try
	{	
		$reqCreate = 'UPDATE playerSchemas SET startDecrypt = NOW(), endDecrypt = ADDTIME(NOW(), :pTime) WHERE  idPlayer = :pIdPlayer AND idSchema = :pSchemaID';
		$reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);
		
		$reqPrepare->bindParam(':pIdPlayer',$pPlayerId);
		$reqPrepare->bindParam(':pSchemaID',$pSchemaID);
		//<!--$reqPrepare->bindParam(':pStart',$pDateStart);-->
		$reqPrepare->bindParam(':pEnd',$pDateEnd);
	
		$pPlayerId = $playerID;	
		$pSchemaID = $schemaID;	
		$pDateStart = $start;	
		$pDateEnd = $end;	

		$reqPrepare->execute();
	}
	catch(Exception $e)	
	{
		$GLOBALS['retour'] = $GLOBALS['error_start_unlock'].$e-> getMessage();
		endScript();
	}	
}

function getSchemaType($schemaID)
{
	try
	{		
		$req = 'SELECT id,gene1,gene2,gene3,tableXenos,type,decryptTime,skipHCCost,gene1quant,gene2quant,gene3quant,xenoName FROM schemasXenos WHERE id = ?';
		$reqPrepared = $GLOBALS['bdd']->prepare($req);		
		if($reqPrepared->execute(array($schemaID)))
		{
			$result = $reqPrepared->fetch();
			return $result;
		}		
		else return null;		
	}
	catch(Exception $e)	
	{
		$GLOBALS['retour'] = $GLOBALS['error_schema_type_not_found'].$e-> getMessage();
		endScript();
	}	
}

function changeEndTimeSchema($schemaID)
{
	$schema = getSchemaType($schemaID);
	try
	{            
		$reqCreate = 'UPDATE playerSchemas SET endDecrypt = NOW() WHERE id= :pId';
		$reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);
	
		$reqPrepare->bindParam(':pId',$pID);
		$pID = $schema->id;
		$reqPrepare->execute();
	}
	catch(Exception $e)    
	{
		$GLOBALS['retour'] = $GLOBALS['error_endtime_schema'].$e-> getMessage();
		endScript();
	} 		
}


function createUser($idFB, $name)
{
	try
	{		
		$reqCreate = 'INSERT INTO player (idFb, level, xp, currentEnergy, maxEnergy, ressource, softCurrency, hardCurrency, FTUEsteps, dateConnexion, nameFb) VALUES (:pIdFb, :pLevel, :pXp, :pCurrentEnergy, :pMaxEnergy, :pRessource, :pSoftCurrency, :pHardCurrency, :pFTUEsteps, NOW(), :pName)';
		$reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);
		$reqPrepare->bindParam(':pIdFb',$pIdFB);
		$reqPrepare->bindParam(':pLevel',$pLevel);
		$reqPrepare->bindParam(':pXp',$pXp);
		$reqPrepare->bindParam(':pCurrentEnergy',$pCurrentEnergy);
		$reqPrepare->bindParam(':pMaxEnergy',$pMaxEnergy);
		$reqPrepare->bindParam(':pRessource',$pRessource);
		$reqPrepare->bindParam(':pSoftCurrency',$pSoftCurrency);
		$reqPrepare->bindParam(':pHardCurrency',$pHardCurrency);
		$reqPrepare->bindParam(':pFTUEsteps',$pFTUEsteps);
		$reqPrepare->bindParam(':pName',$pName);
		
		$pIdFB = $idFB;	
		$pLevel	= 1;	
		$pXp = 0;
		$pCurrentEnergy = $GLOBALS['player_energy'];
		$pMaxEnergy = $GLOBALS['player_maxEnergy'];
		$pRessource = $GLOBALS['player_ressource'];
		$pSoftCurrency = $GLOBALS['player_softCurrency'];
		$pHardCurrency = $GLOBALS['player_hardCurrency'];
		$pFTUEsteps= 0;
		$pName = $name;
		
		$reqPrepare->execute();

		$reqGet = 'SELECT * FROM player WHERE idFb = ?';
		$reqPrepared = $GLOBALS['bdd']->prepare($reqGet);
		if($reqPrepared->execute(array($idFB)))
		{
			$result = $reqPrepared->fetch();
			//$result -> { "firstTime" } = 'true';
			return $result;
		}	
	}
	catch(Exception $e)	
	{
		$GLOBALS['retour'] = $GLOBALS['error_create_player'].$e-> getMessage();
		endScript();
	}	
}


	//buildings
function getPlayerBuildings($PlayerId)
{
	try
	{		
		$req = 'SELECT 	buildingId, buildingEnd, buildingStart, currentLevel, idBuildingType, type, x, y, regionX, regionY, mode, idRegion, globalX, globalY, layer FROM building WHERE idPlayer = ?';
		$reqPrepared = $GLOBALS['bdd']->prepare($req);		
		if($reqPrepared->execute(array($PlayerId)))
		{
			$allResult = $reqPrepared->fetchALL();
			return $allResult;
		}	

	}
	catch(Exception $e)	
	{
		$GLOBALS['retour'] = $GLOBALS['error_getBuildings'].$e-> getMessage();
		endScript();
	}		
}

function getPlayerDestructable($PlayerId)
{
	try
	{		
		$req = 'SELECT destructableId, endOfDestructionTime, destructionTime, idDestructableType, type, x, y, regionX, regionY, mode, idRegion, layer FROM destructable WHERE idPlayer = ?';
		$reqPrepared = $GLOBALS['bdd']->prepare($req);		
		if($reqPrepared->execute(array($PlayerId)))
		{
			$allResult = $reqPrepared->fetchALL();
			return $allResult;
		}	

	}
	catch(Exception $e)	
	{
		$GLOBALS['retour'] = $GLOBALS['$error_getDestructible'].$e-> getMessage();
		endScript();
	}	
}

function getAliens($PlayerId)
{
	try
	{		
		$req = 'SELECT idAlien, idBuilding, type, name, nomPropre, level, mode, startTime, endTime, stamina FROM aliens WHERE idPlayer = ?';
		$reqPrepared = $GLOBALS['bdd']->prepare($req);		
		if($reqPrepared->execute(array($PlayerId)))
		{
			$allResult = $reqPrepared->fetchALL();
			return $allResult;
		}	

	}
	catch(Exception $e)	
	{
		$GLOBALS['retour'] = $GLOBALS['$error_getAlien'].$e-> getMessage();
		endScript();
	}	
}

function getBufferTypes()
{
	$req = 'SELECT id, name, nomenclature, type, nbUpgrade, time, levelReqUp1, levelReqUp2, levelReqUp3, upgradeCost1, upgradeCost2, upgradeCost3, upgradeTime1, upgradeTime2, upgradeTime3, buffType, buffCoef1, buffCoef2, buffCoef3, buffCoef4 FROM AlienBuffer';
	try 
	{
		$reqPrepared = $GLOBALS['bdd']->prepare($req);
		$reqPrepared->execute();
		$result = $reqPrepared->fetchAll();
	}
	catch(Exception $e)
	{
		$GLOBALS['retour'] = $GLOBALS['error_getbuffer'].$e-> getMessage();
		endScript();
	}
	return $result;		
}

function getProdTypes() 
{
	$req = 'SELECT id, name,nomenclature, type, nbUpgrade, time, levelReqUp1, levelReqUp2, levelReqUp3, upgradeCost1, upgradeCost2, upgradeCost3, upgradeTime1, upgradeTime2, upgradeTime3, maxProd, prodTime, prodByCycle, prodSpeed FROM AlienProducer';
	try 
	{
		$reqPrepared = $GLOBALS['bdd']->prepare($req);
		$reqPrepared->execute();
		$result = $reqPrepared->fetchAll();
	}
	catch(Exception $e)
	{
		$GLOBALS['retour'] = $GLOBALS['error_getprod'].$e-> getMessage();
		endScript();
	}
	return $result;	
}

function getEsthTypes()
{
	$req = 'SELECT id, type, name, nomenclature, time FROM AlienEsthetique';
	try 
	{
		$reqPrepared = $GLOBALS['bdd']->prepare($req);
		$reqPrepared->execute();
		$result = $reqPrepared->fetchAll();
	}
	catch(Exception $e)
	{
		$GLOBALS['retour'] = $GLOBALS['error_getesth'].$e-> getMessage();
		endScript();
	}
	return $result;	
}

function getSpeFeatTypes()
{
	$req = 'SELECT id, type, name, nomenclature, power, stamina, time  FROM AlienForeur';
	try 
	{
		$reqPrepared = $GLOBALS['bdd']->prepare($req);
		$reqPrepared->execute();
		$result = $reqPrepared->fetchAll();
	}
	catch(Exception $e)
	{
		$GLOBALS['retour'] = $GLOBALS['error_getspefeat'].$e-> getMessage();
		endScript();
	}
	return $result;	
}

function addAlien($idPlayer, $idBuilding, $idAlien, $type, $name, $nomPropre, $stamina, $time, $firstTime = false )
{
	$AlienInfo = new stdClass();
	try
	{	
		$reqCreate = 'INSERT INTO aliens (idPlayer, idBuilding, idAlien, type, level, mode, name, nomPropre, stamina, startTime, endTime) VALUES (:pPlayerID, :pIdBuilding, :pIdAlien, :pType, :pLevel, :pMode, :pName, :pNomPropre, :pStamina, NOW(), ADDTIME(NOW(), :pTime))';
		$reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);
		
		$reqPrepare->bindParam(':pPlayerID',$pPlayerId);
		$reqPrepare->bindParam(':pIdBuilding',$pIdBuilding);
		$reqPrepare->bindParam(':pIdAlien',$pIdAlien);
		$reqPrepare->bindParam(':pLevel',$pLevel);
		$reqPrepare->bindParam(':pMode', $pMode);
		$reqPrepare->bindParam(':pType',$pType);
		$reqPrepare->bindParam(':pName', $pName);
		$reqPrepare->bindParam(':pNomPropre', $pNomPropre);
		$reqPrepare->bindParam(':pStamina', $pStamina);
		$reqPrepare->bindParam(':pTime',$pTime);
		
		$pPlayerId = $idPlayer;	
		$pIdBuilding = $idBuilding;	
		$pIdAlien = $idAlien;	
		$pType = $type;
		$pLevel = 1;
		$pMode = "Constructing";
		$pName = $name;
		$pNomPropre = $nomPropre;
		if ($stamina == null)
		{
			$pStamina = 0;
		}
		
		else $pStamina =  $stamina;
		$pTime = $time;
		
		$reqPrepare-> execute();
		
		if ($firstTime)
		{$reqCreate = 'SELECT idAlien, startTime, endTime FROM aliens WHERE idPlayer = :pIdPlayer AND idAlien = :pIdAlien';
		$reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);
		
		$reqPrepare->bindParam(':pIdPlayer',$pPlayerId);
		$reqPrepare-> bindParam(':pIdAlien', $pAlienId);
		
		$pPlayerId = $idPlayer;
		$pAlienId = $idAlien;
		
		$reqPrepare-> execute();
		
		$dataAlien = new stdClass();
		$result = $reqPrepare-> fetch();
		
		$dataAlien -> { "Values" } = $result;
		echo json_encode($dataAlien);}
		
		//return $result;
		
		//$AlienInfo -> { "date" } = getInfosAlien($idAlien,$idPlayer);
		//$AlienInfo -> { "dateEnd" } = $regionData;
		
		/*$result = $reqPrepare-> fetchAll();
		return $result;*/
		
		
	}
	catch(Exception $e)	
	{
		$GLOBALS['retour'] = $GLOBALS['error_addAlien'].$e-> getMessage();
		endScript();
	}	
}



function changeAlienIdBuilding($idBuilding, $idAlien)
{
	
	try
	{	
		$reqCreate = 'UPDATE aliens SET idBuilding = :pIdBuilding WHERE idAlien= :pIdAlien';
		$reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);
		
		
		$reqPrepare->bindParam(':pIdBuilding',$pIdBuilding);
		$reqPrepare->bindParam(':pIdAlien',$pIdAlien);
		
		
		$pIdBuilding = $idBuilding;	
		$pIdAlien = $idAlien;	
		
		$reqPrepare-> execute();
		
		
	}
	catch(Exception $e)	
	{
		$GLOBALS['retour'] = $GLOBALS['error_change_ID_alien'].$e-> getMessage();
		endScript();
	}	
}

function getInfosAlien($idAlien, $idPlayer)
{
	try
	{	
		$reqCreate = 'SELECT startTime, endTime FROM aliens WHERE idPlayer = :pIdPlayer AND idAlien = :pIdAlien';
		$reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);
		
		$reqPrepare->bindParam(':pIdPlayer',$pPlayerId);
		$reqPrepare-> bindParam(':pIdAlien', $pAlienId);
		
		$pPlayerId = $idPlayer;
		$pAlienId = $idAlien;
		
		$reqPrepare>execute();
		$result = $reqPrepare > fetchAll();
		
		return $result;
	}
	
	catch(Exception $e)	
	{
		$GLOBALS['retour'] = $GLOBALS['error_addAlien'].$e-> getMessage();
		endScript();
	}
}

//




function addbuilding($name, $playerID, $regionX, $regionY, $x, $y, $globalX, $globalY, $layer, $idBuilding, $first = false, $mode = "Constructing")
{
	$buildingType = getBuildingType($name);
	if($buildingType != null) 	newBuilding($buildingType, $name, $playerID, $regionX, $regionY, $x, $y, $globalX, $globalY, $layer, $idBuilding, $first, $mode);		
}

function newBuilding($type, $name, $playerID, $regionX, $regionY, $x, $y, $globalX, $globalY, $layer, $idBuilding, $first = false, $mode = "Constructing")
{
	try
	{	
		$reqCreate = 'INSERT INTO building (idPlayer, idBuildingType, currentLevel, buildingEnd, mode, regionX, regionY, type, x, y, idRegion, globalX, globalY, layer, buildingStart, buildingId) VALUES (:pPlayerID, :pIdBuildingType, :pCurrentLevel, ADDTIME(NOW(), :pBuildingEnd), :pMode, :pRegionX, :pRegionY, :pType, :pX, :pY, :pIdRegion, :pGlobalX, :pGlobalY, :pLayer, NOW(), :pBuildingId)';
		$reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);
		
		$reqPrepare->bindParam(':pPlayerID',$pPlayerId);
		$reqPrepare->bindParam(':pIdBuildingType',$pIdBuildingType);
		$reqPrepare->bindParam(':pCurrentLevel',$pCurrentLevel);
		$reqPrepare->bindParam(':pBuildingEnd',$pBuildingEnd);
		$reqPrepare->bindParam(':pMode',$pMode);
		$reqPrepare->bindParam(':pRegionX',$pRegionX);
		$reqPrepare->bindParam(':pRegionY',$pRegionY);
		$reqPrepare->bindParam(':pType',$pType);
		$reqPrepare->bindParam(':pX',$pX);
		$reqPrepare->bindParam(':pY',$pY);
		$reqPrepare->bindParam(':pIdRegion',$pIdRegion);
		$reqPrepare->bindParam(':pGlobalX',$pGlobalX);
		$reqPrepare->bindParam(':pGlobalY',$pGlobalY);
		$reqPrepare->bindParam(':pLayer',$pLayer);
		$reqPrepare->bindParam(':pBuildingId',$pBuildingdId);
		
		$pPlayerId = $playerID;	
		$pIdBuildingType = $type->id;	
		$pCurrentLevel = 1;
		$pBuildingEnd = $first? "NOW()": $type->buildingTime;
		$pMode = $mode;
		$pRegionX = $regionX;
		$pRegionY = $regionY;
		$pType = $name;
		$pX= $x;
		$pY= $y;
		$pIdRegion = 0;
		$pGlobalX = $globalX;
		$pGlobalY = $globalY;
		$pLayer = $layer;
		$pBuildingdId = $idBuilding;

		
		$reqPrepare->execute();
	}
	catch(Exception $e)	
	{
		$GLOBALS['retour'] = $GLOBALS['error_create_building'].$e-> getMessage();
		endScript();
	}		
}

function getBuildingType($name)
{
	try
	{	
		$req = 'SELECT  buildingName, buildingTime, category, energyCost, hardCurrencyCost, id, requiredPlayerLevel, ressourcesCost, softCurrencyCost, SellingCost, skipCDcostHC, description, upgradeNumber, levelUpgrade1, levelUpgrade2, levelUpgrade3, upgradeCost1, upgradeCost2, upgradeCost3, upgradeTime1, upgradeTime2, upgradeTime3 FROM buildingType WHERE buildingName = ?';
		$reqPrepared = $GLOBALS['bdd']->prepare($req);		
		if($reqPrepared->execute(array($name)))
		{
			$result = $reqPrepared->fetch();
			return $result;
		}		
		else return null;		
	}
	catch(Exception $e)	
	{
		$GLOBALS['retour'] = $GLOBALS['error_bat_type_not_found'].$e-> getMessage();
		endScript();
	}		
}

function getBuildingTypes()
{
	$req = 'SELECT buildingName, buildingTime, category, energyCost, hardCurrencyCost, id, requiredPlayerLevel, ressourcesCost, softCurrencyCost, SellingCost, skipCDcostHC, description, upgradeNumber, levelUpgrade1, levelUpgrade2, levelUpgrade3, upgradeCost1, upgradeCost2, upgradeCost3, upgradeTime1, upgradeTime2, upgradeTime3 FROM buildingType';
	try 
	{
		$reqPrepared = $GLOBALS['bdd']->prepare($req);
		$reqPrepared->execute();
		$result = $reqPrepared->fetchAll();
	}
	catch(Exception $e)
	{
		$GLOBALS['retour'] = $GLOBALS['error_bat_type_not_found'].$e-> getMessage();
		endScript();
	}
	return $result;	
}

function addDestructable($name, $playerID, $regionX, $regionY, $x, $y, $layer, $idDestructable)
{
	$destructableType = getDestructableType($name);
	if ($destructableType != null) newDestructable($destructableType, $name, $playerID, $regionX, $regionY, $x, $y, $layer, $idDestructable);
}

function newDestructable($destructableType, $name, $playerID, $regionX, $regionY, $x, $y, $layer, $idDestructable)
{
	try
	{	
		$reqCreate = 'INSERT INTO destructable (idPlayer, idDestructableType, mode, regionX, regionY, type, x, y, idRegion, layer, destructableId) VALUES (:pPlayerID, :pIdDestructableType, :pMode, :pRegionX, :pRegionY, :pType, :pX, :pY, :pIdRegion, :pLayer, :pDestructableId)';
		$reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);
		
		$reqPrepare->bindParam(':pPlayerID',$pPlayerId);
		$reqPrepare->bindParam(':pIdDestructableType',$pIdDestructableType);
		$reqPrepare->bindParam(':pMode',$pMode);
		$reqPrepare->bindParam(':pRegionX',$pRegionX);
		$reqPrepare->bindParam(':pRegionY',$pRegionY);
		$reqPrepare->bindParam(':pType',$pType);
		$reqPrepare->bindParam(':pX',$pX);
		$reqPrepare->bindParam(':pY',$pY);
		$reqPrepare->bindParam(':pIdRegion',$pIdRegion);
		$reqPrepare->bindParam(':pLayer',$pLayer);
		$reqPrepare->bindParam(':pDestructableId',$pDestructableId);
		
		$pPlayerId = $playerID;	
		$pIdDestructableType = $destructableType->id;
		$pMode = "Waiting";
		$pRegionX = $regionX;
		$pRegionY = $regionY;
		$pType = $name;
		$pX= $x;
		$pY= $y;
		$pIdRegion = getIDRegion($playerID,$regionX,$regionY);
		$pLayer = $layer;
		$pDestructableId = $idDestructable;

		
		$reqPrepare->execute();
	}
	catch(Exception $e)	
	{
		$GLOBALS['retour'] = $GLOBALS['error_create_destructible'].$e-> getMessage();
		endScript();
	}		
}

function getIDRegion($playerID, $pX, $pY)
{
	try
	{
		$reqCreate = 'SELECT id FROM regions WHERE idPlayer = :pPlayerID AND x = :pX AND y = :pY';
		$reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);
		
		$reqPrepare->bindParam(':pPlayerID',$pPlayerId);
		$reqPrepare->bindParam(':pX',$pCoordX);
		$reqPrepare-> bindParam(':pY', $pCoordY);
		
		$pPlayerId = $playerID;	
		$pCoordX = $pX;
		$pCoordY = $pY;
		
		$result = $reqPrepare-> fetch();
		return $result;
	}
	
	catch(Exception $e)	
	{
		$GLOBALS['retour'] = $GLOBALS['error_create_destructible'].$e-> getMessage();
		endScript();
	}
}

function getDestructableType($name)
{
	try
	{		
		$req = 'SELECT destructableTime, id, softCurrencyCost, skipCDcostHC FROM destructableType WHERE destructableName = ?';
		$reqPrepared = $GLOBALS['bdd']->prepare($req);		
		if($reqPrepared->execute(array($name)))
		{
			$result = $reqPrepared->fetch();
			return $result;
		}		
		else return null;		
	}
	catch(Exception $e)	
	{
		$GLOBALS['retour'] = $GLOBALS['error_dest_type_not_found'].$e-> getMessage();
		endScript();
	}	
}
function getDestructableTypes()
{
	$req = 'SELECT destructableName, softCurrencyCost, destructableTime, skipCDcostHC, width, height FROM destructableType';
	
	try
	{
		$reqPrepared = $GLOBALS['bdd']->prepare($req);
		$reqPrepared->execute();
		$result = $reqPrepared->fetchAll();
	}
	
	catch (Exception $e)
	{
		$GLOBALS['retour'] = $GLOBALS['$error_getDestructible'].$e-> getMessage();
		endScript();
	}
	
	return $result;

}

function releaseBuildingMode($id, $idPlayer, $mode)
{
		try
        {            
            $reqCreate = 'UPDATE building SET mode= :pMode WHERE buildingId= :pId AND idPlayer= :pIdPlayer';
			$reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);
		
			$reqPrepare->bindParam(':pId',$pID);
			$reqPrepare->bindParam(':pIdPlayer',$pIdPlayer);
			$reqPrepare->bindParam(':pMode',$pMode);
			
			$pID = $id;
			$pIdPlayer = $idPlayer;
			$pMode = $mode;
			
			$reqPrepare->execute();
        }
        catch(Exception $e)    
        {
			$GLOBALS['retour'] = $GLOBALS['error_mode_building'].$e-> getMessage();
           endScript();
        } 			
}

function releaseAlienMode($alienId, $idPlayer, $mode, $timeEnd)
{
	try
        {            
            $reqCreate = 'UPDATE aliens SET mode= :pMode, endTime = :pTime WHERE idAlien= :pAlienId AND idPlayer= :pIdPlayer';
			$reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);
		
			$reqPrepare->bindParam(':pAlienId',$pAlienID);
			$reqPrepare->bindParam(':pIdPlayer',$pIdPlayer);
			$reqPrepare->bindParam(':pMode',$pMode);
			$reqPrepare->bindParam(':pTime',$pTimeEnd);
			
			$pAlienID = $alienId;
			$pIdPlayer = $idPlayer;
			$pMode = $mode;
			$pTimeEnd = $timeEnd;
			
			$reqPrepare->execute();
        }
        catch(Exception $e)    
        {
			$GLOBALS['retour'] = $GLOBALS['error_mode_building'].$e-> getMessage();
           endScript();
        } 
}

function changeEndTimeBuilding($id, $endTime)
{
		try
        {            
            $reqCreate = 'UPDATE building SET buildingEnd= NOW() WHERE id= :pId';
			$reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);
		
			$reqPrepare->bindParam(':pId',$pID);
			//$reqPrepare->bindParam(':pEndTime',$pEndTime);
			
			$pID = $id;
			//$pEndTime = $endTime;
			
			$reqPrepare->execute();
        }
        catch(Exception $e)    
        {
			$GLOBALS['retour'] = $GLOBALS['error_endtime_building'].$e-> getMessage();
        	endScript();
        } 		
}

function changeXpLevel($id, $xp, $level)
{
	try
	{
        $reqCreate = 'UPDATE player SET xp= :pXp, level= :pLevel WHERE id= :pId';
		$reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);	
		$reqPrepare->bindParam(':pId',$pId);
		$reqPrepare->bindParam(':pXp',$pXp);
		$reqPrepare-> bindParam(':pLevel', $pLevel);
		
		$pId = $id;
		$pXp = $xp;
		$pLevel = $level;
		$reqPrepare-> execute();
	}
	catch(Exception $e)	
	{
		$GLOBALS['retour'] = $GLOBALS['error_xp'].$e-> getMessage();
		endScript();
	}		
}

function changeBuildingLevel($id, $playerID, $level)
{
	try
	{
        $reqCreate = 'UPDATE building SET currentLevel= :pLevel WHERE buildingId= :pId  AND idPlayer= :pIdPlayer';
		$reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);	
		$reqPrepare->bindParam(':pId',$pId);
		$reqPrepare->bindParam(':pIdPlayer',$playerID);
		$reqPrepare-> bindParam(':pLevel', $pLevel);
		
		$pId = $id;
		$pIdPlayer = $playerID;
		$pLevel = $level;
		$reqPrepare-> execute();
	}
	catch(Exception $e)	
	{
		$GLOBALS['retour'] = $GLOBALS['error_building_level'].$e-> getMessage();
		endScript();
	}		
}

function releaseBuildingPosition($id,$idPlayer, $regionX, $regionY, $x, $y)
    {
        try
        {            
            $reqCreate = 'UPDATE building SET regionX= :pRegionX, regionY= :pRegionY, x= :pX, y= :pY WHERE buildingId= :pId AND idPlayer= :pIdPlayer';
			$reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);
		
			$reqPrepare->bindParam(':pRegionX',$pRegionX);
			$reqPrepare->bindParam(':pRegionY',$pRegionY);
			$reqPrepare->bindParam(':pX',$pX);
			$reqPrepare->bindParam(':pY',$pY);
			$reqPrepare->bindParam(':pId',$pID);
			$reqPrepare->bindParam(':pIdPlayer',$pIdPlayer);
			
			$pRegionX = $regionX;
			$pRegionY = $regionY;
			$pX = $x;
			$pY = $y;
			$pID = $id;
			$pIdPlayer = $idPlayer;
			
			$reqPrepare->execute();
        }
        catch(Exception $e)    
        {
        $GLOBALS['retour'] = $GLOBALS['error_building_changePos'].$e-> getMessage();
           endScript();
        }        
    }
    
function destroyBuilding($id, $idPlayer)
    {
        try
        {
            $reqCreate = 'DELETE FROM building WHERE buildingId= :pId AND idPlayer = :pIdPlayer';
			$reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);
		
			$reqPrepare->bindParam(':pId',$pId);
			$reqPrepare->bindParam(':pIdPlayer',$pIdPlayer);
			
			$pId = $id;
			$pIdPlayer = $idPlayer;
			
			$reqPrepare->execute();
        }
        catch(Exception $e)    
        {
        	$GLOBALS['retour'] = $GLOBALS['error_destroy_building'].$e-> getMessage();
            endScript();
        }
    }
	function destroyDestructible($id, $idPlayer)
	
    {
        try
        {
            $reqCreate = 'DELETE FROM destructable WHERE destructableId= :pId AND idPlayer = :pIdPlayer';
			$reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);
		
			$reqPrepare->bindParam(':pId',$pId);
			$reqPrepare->bindParam(':pIdPlayer',$pIdPlayer);
			
			$pId = $id;
			$pIdPlayer = $idPlayer;
			
			$reqPrepare->execute();
        }
        catch(Exception $e)    
        {
        	$GLOBALS['retour'] = $GLOBALS['error_destroy_destructable'].$e-> getMessage();
            endScript();
        }
    }
	
	
	function releaseDestructibleMode($id, $idPlayer, $mode, $name)
	{
		$destructableType = getDestructableType($name);
		if ($destructableType == null)
		{
			$GLOBALS['retour'] = $GLOBALS['error_mode_destructable'].$e-> getMessage();
			endScript();
		}
		
		try
        {            
            $reqCreate = 'UPDATE destructable SET mode= :pMode, destructionTime = NOW(), endOfDestructionTime = ADDTIME(NOW(),:pTime) WHERE destructableId= :pId AND idPlayer= :pIdPlayer';
			$reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);
		
			$reqPrepare->bindParam(':pId',$pID);
			$reqPrepare->bindParam(':pIdPlayer',$pIdPlayer);
			$reqPrepare->bindParam(':pMode',$pMode);
			$reqPrepare->bindParam(':pTime',$pDestructionTime);
			
			$pID = $id;
			$pIdPlayer = $idPlayer;
			$pMode = $mode;
			$pDestructionTime = $destructableType-> destructableTime;
			
			$reqPrepare->execute();
        }
        catch(Exception $e)    
        {
			$GLOBALS['retour'] = $GLOBALS['error_mode_destructable'].$e-> getMessage();
           endScript();
        }
	}
	
	function addRegion($idPlayer,$x,$y)
	{
		try
        {
      
            $reqCreate = 'INSERT INTO region (idPlayer,x,y) VALUES (:pIdPlayer,:pX,:pY)';
			$reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);
		
			$reqPrepare->bindParam(':pIdPlayer',$pIdPlayer);
			$reqPrepare->bindParam(':pX',$pX);
			$reqPrepare->bindParam(':pY',$pY);
			
			$pIdPlayer = $idPlayer;
			$pX = $x;
			$pY = $y;
			
			$reqPrepare->execute();
        }
        catch(Exception $e)    
        {
        	$GLOBALS['retour'] = $GLOBALS['error_add_region'].$e-> getMessage();
            endScript();
        }
	
	}
	
	function getRegions($idPlayer)
	{
		try
        {
            $reqCreate = 'SELECT x,y FROM region WHERE idPlayer = :pIdPlayer';
			$reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);
		
			$reqPrepare->bindParam(':pIdPlayer',$pIdPlayer);
			
			$pIdPlayer = $idPlayer;
			
			 
			$reqPrepare-> execute();
			$result = $reqPrepare-> fetchALL();
			
			return $result;
        }
        catch(Exception $e)    
        {
        	$GLOBALS['retour'] = $GLOBALS['error_get_regions'].$e-> getMessage();
            endScript();
        }
	}

	///// Currency & ressources ////
	///GET
function checkPlayerValue($playerID, $value, $typeValue)
{
    $playerValue  = getPlayerValue($playerID, $typeValue); 
    $newValue = intval($playerValue->$typeValue) - intval($value); 
    if ($newValue >= 0) changeValueOnPlayer($playerID, $newValue, $typeValue);    
    else {
       $GLOBALS['retour'] = $GLOBALS['error_not_enough_value'];
       endScript();
    }
}

function getPlayerValue($playerID, $typeValue)
{
    try
    {        
        $req = 'SELECT '.$typeValue.' FROM player WHERE id = ?';
        $reqPrepared = $GLOBALS['bdd']->prepare($req);        
        if($reqPrepared->execute(array($playerID)))
        {
            $result = $reqPrepared->fetch();
            return $result;
        }        
        else return null;        
    }
    catch(Exception $e)    
    {
        $GLOBALS['retour'] = $GLOBALS['error_get_value_player'].$e-> getMessage();
        endScript();
    }            
}

    // MODIFY

function changeValueOnPlayer($playerID, $value, $typeValue)
{
    try
       {            
           $reqCreate = 'UPDATE player SET '.$typeValue.'= :pValue WHERE id= :pIdPlayer';
            $reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);
            
            $reqPrepare->bindParam(':pValue', $pValue);
            $reqPrepare->bindParam(':pIdPlayer',$pIdPlayer);
            
            $pValue = $value;
            $pIdPlayer = $playerID;
            
            $reqPrepare->execute();
       }
       catch(Exception $e)    
       {
       $GLOBALS['retour'] = $GLOBALS['error_change_value_player'].$e-> getMessage();
          endScript();
       }      
}

function changeEnergy($playerID, $value)
{
	$req = 'SELECT maxEnergy FROM player WHERE id= ?';
	try
	{
		$reqPrepared = $GLOBALS['bdd']->prepare($req);        
	    if($reqPrepared->execute(array($playerID)))
	    {
	        $result = $reqPrepared->fetch();
	    }        
	    else $result = null;
	}
	catch(Exception $e)
	{
    	$GLOBALS['retour'] = $GLOBALS['error_change_value_player'].$e-> getMessage();
    	endScript();		
	}
	
	if($result != null)
	{
		$typeMaxEnergy = "maxEnergy";
		if(intval($value) >= intval($result->$typeMaxEnergy))
		{
	        $GLOBALS['retour'] = $GLOBALS['error_not_enough_value'];
	        endScript();			
		}
	}
	
	$reqCreate = 'UPDATE player SET currentEnergy = :pValue WHERE id= :pIdPlayer';
       try
       {            
            $reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);           
            $reqPrepare->bindParam(':pValue', $pValue);
            $reqPrepare->bindParam(':pIdPlayer',$pIdPlayer);
            
            $pValue = $value;
            $pIdPlayer = $playerID;
            
            $reqPrepare->execute();
       }
       catch(Exception $e)    
       {
      	  $GLOBALS['retour'] = $GLOBALS['error_change_value_player'].$e-> getMessage();
          endScript();
       }     	
}

function changeMaxEnergy($playerID, $value)
{
	$reqCreate = 'UPDATE player SET maxEnergy = :pValue WHERE id= :pIdPlayer';
       try
       {            
            $reqPrepare = $GLOBALS['bdd']->prepare($reqCreate);           
            $reqPrepare->bindParam(':pValue', $pValue);
            $reqPrepare->bindParam(':pIdPlayer',$pIdPlayer);
            
            $pValue = $value;
            $pIdPlayer = $playerID;
            
            $reqPrepare->execute();
       }
       catch(Exception $e)    
       {
      	  $GLOBALS['retour'] = $GLOBALS['error_change_value_player'].$e-> getMessage();
          endScript();
       }     	
}

function changeFtueStep($playerID, $value)
{
	$req = 'UPDATE player SET FTUEsteps = :pValue WHERE id = :pIdPlayer';
	try
    {            
    	$reqPrepare = $GLOBALS['bdd']->prepare($req);           
        $reqPrepare->bindParam(':pValue', $pValue);
        $reqPrepare->bindParam(':pIdPlayer',$pIdPlayer);
        
        $pValue = $value;
        $pIdPlayer = $playerID;
       
        $reqPrepare->execute();
   }
   catch(Exception $e)    
   {
  	    $GLOBALS['retour'] = $GLOBALS['error_changeFTUEstep'].$e-> getMessage();
        endScript();
   }  
}

function updateGene($playerID, $gene1, $gene2, $gene3, $gene4, $gene5)
{
	$req = 'UPDATE player SET gene1 = :pGene1, gene2 = :pGene2, gene3 = :pGene3, gene4 = :pGene4, gene5 = :pGene5  WHERE id = :pIdPlayer';
	try
    {            
    	$reqPrepare = $GLOBALS['bdd']->prepare($req);
        $reqPrepare->bindParam(':pIdPlayer',$pIdPlayer);
        $reqPrepare->bindParam(':pGene1',$pGene1);
        $reqPrepare->bindParam(':pGene2',$pGene2);
        $reqPrepare->bindParam(':pGene3',$pGene3);
        $reqPrepare->bindParam(':pGene4',$pGene4);
        $reqPrepare->bindParam(':pGene5',$pGene5);
        
        $pIdPlayer = $playerID;
        $pGene1 = $gene1;
        $pGene2 = $gene2;
        $pGene3 = $gene3;
        $pGene4 = $gene4;
        $pGene5 = $gene5;
       
        $reqPrepare->execute();
   }
   catch(Exception $e)    
   {
  	    $GLOBALS['retour'] = $GLOBALS['error_update_gene'].$e-> getMessage();
        endScript();
   } 
}

function getTime()
{
	$req = 'SELECT NOW()';
	try
	{
		$reqPrepared = $GLOBALS['bdd']->prepare($req);       
        $reqPrepared->execute();
        $result = $reqPrepared->fetch();
        echo json_encode($result);
		//return $result;
	}
	
	catch (Exception $e)
	{
		$GLOBALS['retour'] = $GLOBALS['error_time'].$e-> getMessage();
	}
}

function getFriendsAlien($friendsList)
{
		$lFriendList = json_decode($friendsList);
		$reqGet = 'SELECT * FROM aliens WHERE idPlayer IN('.implode(",",$lFriendList).')';
	try
	{
		$reqPrepared = $GLOBALS['bdd']->prepare($reqGet);
		$reqPrepared->execute();
		$result = $reqPrepared->fetchAll();
		$resultAliens = new stdClass();
		$resultAliens -> { "aliens" } = $result;
		echo json_encode($resultAliens);
	}
	catch (Exception $e)
	{
		$GLOBALS['retour'] = $GLOBALS['error_time'].$e-> getMessage();
	}
}

function getFriends($friendList)
{
	$lFriendList = json_decode($friendList);
	$reqGet = 'SELECT * FROM player WHERE idFb IN('.implode(",",$lFriendList).')';
	try
	{
		$reqPrepared = $GLOBALS['bdd']->prepare($reqGet);
		$reqPrepared->execute();
		$result = $reqPrepared->fetchAll();
		$resultFriends = new stdClass();
		$resultFriends -> { "friends" } = $result;
		echo json_encode($resultFriends);		
	}
	catch (Exception $e)
	{
		$GLOBALS['retour'] = $GLOBALS['error_time'].$e-> getMessage();
	}
}


// kill le script et renvoie l'erreur correspondante
function endScript(){
	global $retour;
	echo json_encode($retour);
	die();
}

?>