package com.isartdigital.utils.save;
import com.isartdigital.ruby.Main;
import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.game.sprites.elements.aliens.Alien;
import com.isartdigital.ruby.ui.popin.DailyReward;
import com.isartdigital.ruby.ui.popin.translationCenter.TranslationCenter;
import com.isartdigital.ruby.utils.TimeManager;
import eventemitter3.EventEmitter;
import haxe.DynamicAccess;
import haxe.Http;
import haxe.Json;

typedef TempoBuildingInfo =
{
	var buildingType:String;
	var regionX:Int;
	var regionY:Int;
	var x:Int;
	var y:Int;
	var globalX:Float;
	var globalY:Float;
	var layer:Int;
	var buildingId:String;
}

/**
 * ...
 * @author Adrien Bourdon
 */
class DataBaseAction
{

	/**
	 * instance unique de la classe DataBaseAction
	 */
	private static var instance: DataBaseAction;

	public var activeData = false;
	public static inline var CONNECT:String = "connexion";
	public static inline var NEW_PLAYER:String = "newPlayer";
	public static inline var NEW_BUILDING:String = "addBuilding";
	public static inline var GET_BUILDINGS:String = "getBuildings";
	public static inline var GET_REGIONS:String = "getRegions";
	public static inline var MOVE_BUILDINGS:String = "releaseBuildingPosition";
	public static inline var DESTROY_BUILDINGS:String = "destroyBuilding";
	public static inline var MODE_BUILDINGS:String = "releaseBuildingMode";
	public static inline var ADD_REGION:String = "addRegion";
	public static inline var CHANGE_ENDTIME_BUILDING:String = "changeEndTimeBuilding";
	public static inline var CHANGE_ENERGY:String = "changeEnergy";
	public static inline var CHANGE_MAX_ENERGY:String = "changeMaxEnergy";
	public static inline var CHECK_VALUE:String = "checkValue";
	public static inline var FTUE_ADVANCE:String = "ftueNewStep";
	public static inline var NEW_DESTRUCTIBLE:String = "addDestructible";
	public static inline var MODE_DESTRUCTIBLE:String = "releaseDestructibleMode";
	public static inline var DESTROY_DESTRUCTIBLE:String = "destroyDestructible";
	public static inline var TIME:String = "time";
	public static inline var GET_ALIEN:String = "getAlien";
	public static inline var CHANGE_LEVEL:String = "changeXpLevel";
	public static inline var CHANGE_BUILDING_LEVEL:String = "changeBuildingLevel";
	public static inline var ADD_ALIEN:String = "addAlien";
	public static inline var MODE_ALIEN:String = "modeAlien";
	public static inline var CHANGE_ALIEN_IDBUILDING:String = "changeAlienIdBuilding";

	public static inline var TYPE_SOFTCURRENCY:String = "softCurrency";
	public static inline var TYPE_HARDCURRENCY:String = "hardCurrency";
	public static inline var TYPE_RESSOURCE:String = "ressource";
	public static inline var UPDATE_GENE:String = "updateGene";
	
	public static inline var ADD_SCHEMA:String = "addSchema";
	public static inline var UNLOCK_SCHEMA:String = "unlockSchema";
	public static inline var START_UNLOCK_SCHEMA:String = "startUnlockSchema";
	public static inline var GET_DECRYPT_TIME:String = "getSchemaTimeToDecrypt";
	

	private var tempoBuilding:TempoBuildingInfo;

	private var firstCo:Bool = false;

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): DataBaseAction
	{
		if (instance == null) instance = new DataBaseAction();
		return instance;
	}

	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new()
	{

	}

	public function addBuildingAndChangeRessource(pIdPlayer:Int, pTypeValue:String, pValue:Int, pBuildingType:String,pBuildingId:String, pRegionX:Int, pRegionY:Int, pX:Int, pY:Int, pGlobalX:Float, pGlobalY:Float, pLayer:Int, ?pMNCost :Int = 0):Void
	{
		tempoBuilding = {
			buildingType:pBuildingType,
			regionX:pRegionX,
			regionY:pRegionY,
			x:pX,
			y:pY,
			globalX:pGlobalX,
			globalY:pGlobalY,
			layer:pLayer,
			buildingId:pBuildingId
		}
		changeCurrency(pIdPlayer, pTypeValue, pValue, true);
		if (pMNCost != 0) changeCurrency(pIdPlayer, "ressource", pMNCost);
	}

	public function getData(pAction:String):Void
	{
		if (activeData)
		{
			var lCall:Http = new Http("php/action.php?"+pAction);
			lCall.onData = onData;
			lCall.onError = onError;
			lCall.request(true);
		}
	}

	public function setData(pAction:String, pContent:String):Void
	{
		if (activeData)
		{
			var lCall:Http = new Http("php/action.php?action=" + pAction);
			lCall.setParameter("data", pContent);
			lCall.onData = onData;
			lCall.onError = onError;
			lCall.request(true);
		}
	}

	/**
	 * check la BDD, recupère les information du joueurs en fonction de son idFb
	 * si le joueurs n'existe pas, un nouveau joueur est créé avant
	 * @param	pContent
	 */
	public function connexionPlayer(pIdFb:String, pName:String):Void
	{
		if (activeData)
		{
			if (pIdFb != "")
			{
				var lCall:Http = new Http("php/action.php?action=" + CONNECT);
				lCall.setParameter("data", pIdFb);
				lCall.setParameter("name", pName);
				lCall.onData = onPlayerInfo;
				lCall.onError = onError;
				lCall.request(true);
			}
			else
			{
				trace("pas d'id facebook");
				return null;
			}
		}
		else return null;
	}

	// les callback :
	public function onPlayerInfo(pData:Dynamic):Void
	{
		var lData:Dynamic = Json.parse(pData);
		DataManager.getInstance().savePlayerInfo(lData);
		//DataManager.getInstance().saveRegionsJson(lData.region);
		//DataManager.getInstance().saveBuildingJson(lData.buidings);

		trace(lData.firstTime);
		if (lData.firstTime) 
		{
			trace("ton pere c'est sa premiere fois");
			//Main.getInstance().eventNewPlayer(lData.playerInfo.idFb);
		}
		getServerTime();
		Main.getInstance().onSaveLoaded();
	}

	public function addBuilding(pBuildingType:String, pBuildingId:String, pRegionX:Int, pRegionY:Int, pX:Int, pY:Int, pGlobalX:Float, pGlobalY:Float, pLayer:Int):Void
	{
		if (activeData)
		{
			if (pBuildingType != null)
			{
				var lCall:Http = new Http("php/action.php?action=" + NEW_BUILDING);
				lCall.setParameter("type", pBuildingType);
				lCall.setParameter("playerID", Std.string(Player.getInstance().id));
				lCall.setParameter("regionX", Std.string(pRegionX));
				lCall.setParameter("regionY", Std.string(pRegionY));
				lCall.setParameter("x", Std.string(pX));
				lCall.setParameter("y", Std.string(pY));
				lCall.setParameter("globalX", Std.string(pGlobalX));
				lCall.setParameter("globalY", Std.string(pGlobalY));
				lCall.setParameter("layer", Std.string(pLayer));
				lCall.setParameter("buildingID", pBuildingId);
				lCall.onData = onAddBuilding;
				lCall.onError = onError;
				lCall.request(true);
			}
			else
			{
				trace("pas de type de building");
				return null;
			}
		}
		else return null;
	}

	public function addAlien(pAlienID:String, pBuildingId:String, pType:String, pName:String, pNomPropre:String, pStamina:Int, pTime:String):Void
	{
		if (activeData)
		{
			trace("add alien");
			if (pType != null)
			{
				var lCall:Http = new Http("php/action.php?action=" + ADD_ALIEN);
				lCall.setParameter("playerID", Std.string(Player.getInstance().id));
				lCall.setParameter("buildingID", pBuildingId);
				lCall.setParameter("alienID", pAlienID);
				lCall.setParameter("type", pType);
				lCall.setParameter("name", pName);
				lCall.setParameter("nomPropre", pNomPropre);
				lCall.setParameter("stamina", Std.string(pStamina));
				lCall.setParameter("time", pTime);
				lCall.onData = onAlienAdd;
				lCall.onError = onError;
				lCall.request(true);
			}
			else
			{
				trace("pas de type de building");
				return null;
			}
		}
		else return null;
	}
	
	
	public function changeAlienIdBuilding(pAlienID:String, pBuildingId:String):Void
	{
		if (activeData)
		{
			if (pAlienID != null &&  pBuildingId != null)
			{
				var lCall:Http = new Http("php/action.php?action=" + CHANGE_ALIEN_IDBUILDING);
				lCall.setParameter("buildingID", pBuildingId);
				lCall.setParameter("alienID", pAlienID);
				lCall.onData = onData;
				lCall.onError = onError;
				lCall.request(true);
			}
			else
			{
				trace("pas de parametres");
				return null;
			}
		}
		else return null;
	}

	private function onAlienAdd(pData:Dynamic):Void
	{
	
		
	}

	public function onAddBuilding(pData:Dynamic):Void
	{
		if (pData != "")
		{
			var lData:Dynamic = Json.parse(pData);
			DataManager.getInstance().saveBuildingJson(lData);
		}
	}

	public function releaseBuildingPosition(pID:String, pRegionX:Int, pRegionY:Int, pX:Int, pY:Int):Void
	{
		if (activeData)
		{
			if (pID != null)
			{
				var lCall:Http = new Http("php/action.php?action=" + MOVE_BUILDINGS);
				lCall.setParameter("id", pID);
				lCall.setParameter("idPlayer", Std.string(Player.getInstance().id));
				lCall.setParameter("regionX", Std.string(pRegionX));
				lCall.setParameter("regionY", Std.string(pRegionY));
				lCall.setParameter("x", Std.string(pX));
				lCall.setParameter("y", Std.string(pY));
				lCall.onData = onData;
				lCall.onError = onError;
				lCall.request(true);
			}
			else
			{
				trace("Erreur position Building");
				return null;
			}
		}
		else return null;
	}

	public function destroyBuilding(pID:String):Void
	{
		if (activeData)
		{
			if (pID != null)
			{
				var lCall:Http = new Http("php/action.php?action=" + DESTROY_BUILDINGS);
				lCall.setParameter("id", pID);
				lCall.setParameter("idPlayer", Std.string(Player.getInstance().id));
				lCall.onData = onData;
				lCall.onError = onError;
				lCall.request(true);
			}
			else
			{
				trace("Erreur destroy Building");
				return null;
			}
		}
		else return null;
	}

	public function changeExperience(pXp:Int, pLevel:Int):Void
	{
		if (activeData)
		{
			if (pXp != null && pLevel != null)
			{
				var lCall:Http = new Http("php/action.php?action=" + CHANGE_LEVEL);
				lCall.setParameter("playerID", Std.string(Player.getInstance().id));
				lCall.setParameter("xp", Std.string(pXp));
				lCall.setParameter("level", Std.string(pLevel));
				lCall.onData = onData;
				lCall.onError = onError;
				lCall.request(true);
			}
			else
			{
				trace("Erreur changeExperience");
				return null;
			}
		}
		else return null;
	}

	public function changeBuildingLevel(pID:String, pLevel:Int):Void
	{
		if (activeData)
		{
			if (pID != null && pLevel != null)
			{
				var lCall:Http = new Http("php/action.php?action=" + CHANGE_BUILDING_LEVEL);
				lCall.setParameter("id", Std.string(pID));
				lCall.setParameter("playerID", Std.string(Player.getInstance().id));
				lCall.setParameter("level", Std.string(pLevel));
				lCall.onData = onData;
				lCall.onError = onError;
				lCall.request(true);
			}
			else
			{
				trace("Erreur changeBuildingLevel");
				return null;
			}
		}
		else return null;
	}

	public function releaseBuildingMode(pID:String, pMode:String):Void
	{
		if (activeData)
		{
			if (pID != null)
			{
				var lCall:Http = new Http("php/action.php?action=" + MODE_BUILDINGS);
				lCall.setParameter("id", pID);
				lCall.setParameter("idPlayer", Std.string(Player.getInstance().id));
				lCall.setParameter("mode", pMode);
				lCall.onData = onData;
				lCall.onError = onError;
				lCall.request(true);
			}
			else
			{
				trace("Erreur mode Building");
				return null;
			}
		}
		else return null;
	}

	public function addDestructible(pDestructibleType:String, pDestructibleId:String, pRegionX:Int, pRegionY:Int, pX:Int, pY:Int, pLayer:Int):Void
	{
		if (activeData)
		{
			if (pDestructibleType != null)
			{
				var lCall:Http = new Http("php/action.php?action=" + NEW_DESTRUCTIBLE);
				lCall.setParameter("type", pDestructibleType);
				lCall.setParameter("playerID", Std.string(Player.getInstance().id));
				lCall.setParameter("regionX", Std.string(pRegionX));
				lCall.setParameter("regionY", Std.string(pRegionY));
				lCall.setParameter("x", Std.string(pX));
				lCall.setParameter("y", Std.string(pY));
				lCall.setParameter("layer", Std.string(pLayer));
				lCall.setParameter("destructableID", pDestructibleId);
				lCall.onData = onAddDestructable;
				lCall.onError = onError;
				lCall.request(true);
			}
			else
			{
				trace("pas de type de building");
				return null;
			}
		}
		else return null;
	}

	public function onAddDestructable(pData:Dynamic):Void
	{
		trace(pData);
		trace("pas d'erreur sur le add destructable");
		if (pData != "")
		{
			var lData:Dynamic = Json.parse(pData);
			DataManager.getInstance().saveBuildingJson(lData);
		}
	}

	public function destroyDestructible(pID:String):Void
	{
		if (activeData)
		{
			if (pID != null)
			{
				var lCall:Http = new Http("php/action.php?action=" + DESTROY_DESTRUCTIBLE);
				lCall.setParameter("id", pID);
				lCall.setParameter("idPlayer", Std.string(Player.getInstance().id));
				lCall.onData = onData;
				lCall.onError = onError;
				lCall.request(true);
			}
			else
			{
				trace("Erreur destroy Destructible");
				return null;
			}
		}
		else return null;
	}

	public function releaseDestructibleMode(pName:String, pID:String, pMode:String):Void
	{
		if (activeData)
		{
			if (pID != null)
			{
				var lCall:Http = new Http("php/action.php?action=" + MODE_DESTRUCTIBLE);
				lCall.setParameter("id", pID);
				lCall.setParameter("idPlayer", Std.string(Player.getInstance().id));
				lCall.setParameter("mode", pMode);
				lCall.setParameter("name", pName);
				lCall.onData = onData;
				lCall.onError = onError;
				lCall.request(true);
			}
			else
			{
				trace("Erreur mode Destructible");
				return null;
			}
		}
		else return null;
	}
	
	public function releaseAlienMode(pAlienId:String, pMode:String, ?pTimeEnd:Date = null ):Void
	{
		if (activeData)
		{
			if (pAlienId != null)
			{
				var lCall:Http = new Http("php/action.php?action=" + MODE_ALIEN);
				lCall.setParameter("alienId", MODE_ALIEN);
				lCall.setParameter("idPlayer", Std.string(Player.getInstance().id));
				if (pTimeEnd != null) lCall.setParameter("timeEnd",Std.string(pTimeEnd));
				lCall.setParameter("mode", pMode);
				lCall.onData = onData;
				lCall.onError = onError;
				lCall.request(true);
			}
			else
			{
				trace("Erreur mode Destructible");
				return null;
			}
		}
		else return null;
	}

	public function changeEndTimeBuilding(pId:String, pEndTime:Date):Void
	{
		if (activeData)
		{
			if (pId != null)
			{
				var lCall:Http = new Http("php/action.php?action=" + CHANGE_ENDTIME_BUILDING);
				lCall.setParameter("id", pId);
				lCall.setParameter("endTime", Std.string(pEndTime));
				lCall.onData = onData;
				lCall.onError = onError;
				lCall.request(true);
			}
			else
			{
				trace("Erreur no Building id");
				return null;
			}
		}
		else return null;
	}

	public function unlockRegion(regionX:Int, regionY:Int):Void
	{
		if (activeData)
		{
			//if (pID != null)
			{
				var lCall:Http = new Http("php/action.php?action=" + ADD_REGION);
				lCall.setParameter("idPlayer", Std.string(Player.getInstance().id));
				lCall.setParameter("x", Std.string(regionX));
				lCall.setParameter("y", Std.string(regionY));
				lCall.onData = onUnlockRegion;
				lCall.onError = onError;
				lCall.request(true);
			}
			/*else
			{
				trace("Erreur position Building");
				return null;
			}*/
		}
		else return null;
	}

	public function onUnlockRegion(pData:Dynamic):Void
	{
		if (pData != "")
		{
			trace("onData : " + pData);
			trace(Json.parse(pData));
		}
		if (firstCo) addBuilding("AlienPaddock", "AlienPaddock"+Date.now().getTime(), 0, 0, 8, 8, 0, 800, 1);
	}

	public function onData(pData:Dynamic):Void
	{
		if (pData != "")
		{
			trace("onData : " + pData);
			trace(Json.parse(pData));
		}
	}

	public function onError(pError:Dynamic):Void
	{
		trace(pError);
		if (pError != "")
		{
			trace("onError : " + pError);
			trace(Json.parse(pError));
		}
	}

	public function changeCurrency(pIdPlayer:Int, pTypeValue:String, pValue:Int, ?isAddingBuilding:Bool = false):Void
	{

		if (activeData)
		{
			var lCall:Http = new Http("php/action.php?action=" + CHECK_VALUE);
			lCall.setParameter("idPlayer", Std.string(pIdPlayer));
			lCall.setParameter("value", Std.string(pValue));
			lCall.setParameter("typeValue", pTypeValue);
			if (isAddingBuilding) lCall.onData = onChangeCurrencyToAddBuilding;
			else lCall.onData = onData;
			lCall.onError = onError;
			lCall.request(true);
		}
		else return null;
	}

	public function changeEnergy(pIdPlayer:Int, pEnergy:Int):Void
	{
		if (activeData)
		{
			var lCall:Http = new Http("php/action.php?action=" + CHANGE_ENERGY);
			lCall.setParameter("idPlayer", Std.string(pIdPlayer));
			lCall.setParameter("value", Std.string(pEnergy));
			lCall.onData = onData;
			lCall.onError = onError;
			lCall.request(true);
		}
		else return null;
	}

	public function changeMaxEnergy(pIdPlayer:Int, pMaxEnergy:Int):Void
	{
		if (activeData)
		{
			var lCall:Http = new Http("php/action.php?action=" + CHANGE_MAX_ENERGY);
			lCall.setParameter("idPlayer", Std.string(pIdPlayer));
			lCall.setParameter("value", Std.string(pMaxEnergy));
			lCall.onData = onData;
			lCall.onError = onError;
			lCall.request(true);
		}
		else return null;
	}

	public function onChangeCurrencyToAddBuilding(pData:Dynamic):Void
	{

		addBuilding(tempoBuilding.buildingType,tempoBuilding.buildingId, tempoBuilding.regionX, tempoBuilding.regionY, tempoBuilding.x, tempoBuilding.y, tempoBuilding.globalX, tempoBuilding.globalY, tempoBuilding.layer);
	}

	public function changeFtueStep(pIdPlayer:Int, pFTUEstep:Int):Void
	{
		if (activeData)
		{
			var lCall:Http = new Http("php/action.php?action=" + FTUE_ADVANCE);
			lCall.setParameter("idPlayer", Std.string(pIdPlayer));
			lCall.setParameter("value", Std.string(pFTUEstep));
			lCall.onData = onData;
			lCall.onError = onError;
			lCall.request(true);
		}
		else return null;
	}

	public function getServerTime():Void
	{
		if (activeData)
		{
			var lCall:Http = new Http("php/action.php?action=" + TIME);
			lCall.onData = onTime;
			lCall.onError = onError;
			lCall.request(true);
		}
		else return null;
	}

	private function onTime(pData:Dynamic):Void
	{
		trace(pData);
		var parsedData:Dynamic = Json.parse(pData);
		trace(parsedData);
		var time:Date = Date.fromString(Reflect.field(parsedData, "NOW()"));
		//DailyReward.getInstance().dateServer = time;
		TimeManager.getInstance().timeServer = time;
		//trace(TimeManager.getInstance().timeServer);
	}

	public function updateGene():Void
	{
		if (activeData)
		{
			var lCall:Http = new Http("php/action.php?action=" + UPDATE_GENE);
			lCall.setParameter("playerID", Std.string(Player.getInstance().id));
			lCall.setParameter("gene1", Std.string(Player.getInstance().gene1));
			lCall.setParameter("gene2", Std.string(Player.getInstance().gene2));
			lCall.setParameter("gene3", Std.string(Player.getInstance().gene3));
			lCall.setParameter("gene4", Std.string(Player.getInstance().gene4));
			lCall.setParameter("gene5", Std.string(Player.getInstance().gene5));
			lCall.onData = onData;
			lCall.onError = onError;
			lCall.request(true);
		}
		else return null;
	}

	public function getAlienFriends(pList:Dynamic):Void
	{
		if (activeData)
		{
			var lCall:Http = new Http("php/action.php?action=" + "getFriendAlien");
			lCall.setParameter("friendsList", Json.stringify(pList));
			lCall.onData = friendsAliensInfo;
			lCall.onError = onError;
			lCall.request(true);
		}
		else return null;
	}
	
	private function friendsAliensInfo(pData:Dynamic):Void
	{
		if (pData == "") return;
		DataManager.getInstance().loadFriendsAliensInfo(pData);
	}
	
	public function getFriends(pList:Dynamic):Void
	{
		if (activeData)
		{
			var lCall:Http = new Http("php/action.php?action=" + "getFriends");
			lCall.setParameter("friendsList", pList);
			lCall.onData = friendsInfo;
			lCall.onError = onError;
			lCall.request(true);
		}
		else return null;
	}

	private function friendsInfo(pData:Dynamic):Void
	{
		if (pData == "") return;
		DataManager.getInstance().loadFriendsInfo(pData);
	}

	public function getSchemaTimeToDecrypt(pSchemaID:Int):Void
	{
		if (activeData)
		{
			trace("MON ID DE SCHEMA " + pSchemaID);
			var lCall:Http = new Http("php/action.php?action=" + GET_DECRYPT_TIME);
			lCall.setParameter("schemaID", Std.string(pSchemaID));
			lCall.onData = onGetDecryptTime;
			lCall.onError = onError;
			lCall.request(true);	
		}
		else
		{
			trace("pas pu attraper le Décrypt Time");
			return null;
		}		
		
	}
	
	private function onGetDecryptTime(pData:Dynamic):Void
	{
		if (pData != "") DataManager.getInstance().getSchemaTimeToDecrypt(Json.parse(pData).decryptTime);
	}
	
	
	public function addSchema(pSchemaId:Int):Void
	{
		if (activeData)
		{
			var lCall:Http = new Http("php/action.php?action=" + ADD_SCHEMA);
			lCall.setParameter("playerID", Std.string(Player.getInstance().id));
			lCall.setParameter("schemaID", Std.string(pSchemaId));
			lCall.onData = onAddSchema;
			lCall.onError = onError;
			lCall.request(true);
			
		}
		else
		{
			trace("pas pu ajouter le schema");
			return null;
		}
	}
	
	private function onAddSchema(pData:Dynamic):Void
	{
		if (pData != "") trace(pData); 
	}
	
	public function startUnlockSchema(pIdSchema:Int, pStartDecrypt:Date, pEndDecrypt:Date):Void
	{
		if (activeData)
		{
			var lCall:Http = new Http("php/action.php?action=" + START_UNLOCK_SCHEMA);
			lCall.setParameter("playerID", Std.string(Player.getInstance().id));
			lCall.setParameter("schemaID", Std.string(pIdSchema));
			lCall.setParameter("start", Std.string(pStartDecrypt));
			lCall.setParameter("end", Std.string(pEndDecrypt));
			lCall.onData = onData;
			lCall.onError = onError;
			lCall.request(true);	
		}
		else
		{
			trace("pas pu decrypt le schema");
			return null;
		}
	}
	
	public function unlockSchema(pSchemaId:Int):Void
	{
		if (activeData)
		{
			var lCall:Http = new Http("php/action.php?action=" + UNLOCK_SCHEMA);
			lCall.setParameter("playerID", Std.string(Player.getInstance().id));
			lCall.setParameter("schemaID", Std.string(pSchemaId));
			lCall.onData = onData;
			lCall.onError = onError;
			lCall.request(true);	
		}
		else
		{
			trace("pas pu decrypt le schema");
			return null;
		}
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void
	{
		instance = null;
	}

}