package com.isartdigital.utils.save;

import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.game.specialFeature.managers.SpecialFeatureAliens;
import com.isartdigital.ruby.game.sprites.elements.Building;
import com.isartdigital.ruby.game.sprites.elements.ElementType;
import com.isartdigital.ruby.game.sprites.elements.GameElement;
import com.isartdigital.ruby.game.sprites.elements.aliens.Alien;
import com.isartdigital.ruby.game.sprites.elements.aliens.AlienElement;
import com.isartdigital.ruby.game.sprites.elements.aliens.AlienEsthetique;
import com.isartdigital.ruby.game.sprites.elements.aliens.alienspaddockable.AlienBuffer;
import com.isartdigital.ruby.game.sprites.elements.aliens.alienspaddockable.AlienProducer;
import com.isartdigital.ruby.game.sprites.elements.destructible.Destructible;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.translationClass.Schemas;
import com.isartdigital.ruby.game.world.Layer;
import com.isartdigital.ruby.game.world.Region;
import com.isartdigital.ruby.game.world.World;
import com.isartdigital.ruby.ui.popin.incubator.Incubator;
import com.isartdigital.ruby.ui.popin.building.datas.IncubatorSchema;
import com.isartdigital.ruby.ui.popin.codex.CodexData;
import com.isartdigital.ruby.utils.TimeManager;
import js.Lib;
//import com.isartdigital.ruby.ui.popin.building.Incubator;
//import com.isartdigital.ruby.ui.popin.building.datas.IncubatorSchema;
import com.isartdigital.utils.game.clipping.CellManager;
import com.isartdigital.utils.game.clipping.IClippable.Element;
import com.isartdigital.utils.game.iso.IsoManager;
import com.isartdigital.utils.game.pooling.PoolManager;
import com.isartdigital.utils.game.pooling.PoolObject;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.save.BuildingTypes.BuildingType;
import haxe.Json;
import js.Browser;
import pixi.core.math.Point;
import pixi.interaction.EventEmitter;

typedef FriendSave =
{
	var id:Int;
	var idFb:String;
	var langue:String;
	var hardCurrency:Int;
	var softCurrency:Int;
	var ressource:Int;
	var currentEnergy:Int;
	var level:Int;
	var xp:UInt;
	var FTUESteps:Int;
	var maxEnergy:Int;
	@:optional var gene1:Int;
	@:optional var gene2:Int;
	@:optional var gene3:Int;
	@:optional var gene4:Int;
	@:optional var gene5:Int;
	@:optional var schemas:Int;
	@:optional var dateConnexion:String;
	@:optional var daysPlayed:Int;
	@:optional var nameFb:String;
}
/**
 * ...
 * @author Guillaume Zegoudia
 */
class DataManager // extends EventEmitter
{
	private var toSave:Array<RegionSave> = [];
	private var loadedData:Map<String,Element> = new Map<String,Element>();

	//social : contient la liste d'amis du joueur et la liste des aliens des amis du joueurs
	public var friendsList:Array<FriendSave> = new Array<FriendSave>();
	public var alienFriendsList:Array<AlienElement> = new Array<AlienElement>();

	public var schemasList:Array<Schemas> = [];

	private var TOKEN_WORLD:String = "world";

	private var TOKEN_TIME:Float;

	private var buildingSave:Dynamic;
	private var regionSave:Dynamic;

	public var playerSave(default, null):Dynamic;
	public var listBuildingTypes:Map<String, Dynamic> = new Map<String, BuildingType>();
	public var listDestructableTypes(default,null):Map<String, Dynamic> = new Map<String, DestructableType>();
	private var noDataToLoad:EventEmitter;
	private var dataToLoad:EventEmitter;

	/**
	 * instance unique de la classe DataManager
	 */
	private static var instance: DataManager;

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): DataManager
	{
		if (instance == null) instance = new DataManager();
		return instance;
	}

	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new()
	{
		//Browser.window.addEventListener("onunload", unload);
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void
	{
		instance = null;
	}

	/**
	 * Sauvegarde recuperer en BDD des buildings du joueur
	 * @param	pData le json recuperé
	 */
	public function savePlayerInfo(pData:Dynamic)
	{
		playerSave = pData;
	}

	/**
	 * Sauvegarde recuperer en BDD des buildings du joueur
	 * @param	pData le json recuperé
	 */
	public function saveBuildingJson(pData:Dynamic)
	{
		buildingSave = pData;
	}

	/**
	 * Sauvegarde recuperer en BDD des regions du joueur
	 * @param	pData le json recuperé
	 */
	public function saveRegionsJson(pData:Dynamic):Void
	{
		regionSave = pData;
	}

	public function save(pList:Map<String,Element>):Void
	{
		//Data.getInstance().world = pList;
		//Browser.getLocalStorage().setItem(TOKEN_WORLD, Json.stringify(pList));
	}

	/*public function getLocalStorage():Bool
	{
		var myLoadedData:String = Browser.getLocalStorage().getItem(TOKEN_WORLD);

		if (myLoadedData != null)
		{
			//loadData(myLoadedData);
		}

		return myLoadedData != null;
	}*/

	/**
	 * Chargement inGame des données recuperer en bdd, si c'est la 1ere fois qu'un joueur se connecte, rien ne se passe
	 */
	public function loadData():Void
	{
		if (playerSave != null)
		{
			var lPlayerSave:PlayerSave =
			{
				id : playerSave.playerInfo.id,
				fbID : playerSave.playerInfo.idFb,
				level : Std.parseInt(playerSave.playerInfo.level),
				xp : Std.parseInt(playerSave.playerInfo.xp),
				hardCurrency : Std.parseInt(playerSave.playerInfo.hardCurrency),
				softCurrency : Std.parseInt(playerSave.playerInfo.softCurrency),
				ressource : Std.parseInt(playerSave.playerInfo.ressource),
				currentEnergy : Std.parseInt(playerSave.playerInfo.currentEnergy),
				maxEnergy : Std.parseInt(playerSave.playerInfo.maxEnergy),
				ftueSteps : Std.parseInt(playerSave.playerInfo.FTUEsteps),
				gene1:Std.parseInt(playerSave.playerInfo.gene1),
				gene2:Std.parseInt(playerSave.playerInfo.gene2),
				gene3:Std.parseInt(playerSave.playerInfo.gene3),
				gene4:Std.parseInt(playerSave.playerInfo.gene4),
				gene5:Std.parseInt(playerSave.playerInfo.gene5)
			};

			Player.getInstance().loadSave(lPlayerSave);

			/******* REGIONS ********/
			var lRegions:Dynamic = Reflect.field(playerSave, "region");
			if (lRegions)
			{
				for (region in Reflect.fields(lRegions))
				{
					var lRegion:Dynamic =  Reflect.field(lRegions, region);
					World.getInstance().unlockRegion(Std.parseInt(lRegion.x), Std.parseInt(lRegion.y));
				}
			}

			/********* DESTRUCTIBLE **********/
			var lDestructableType:Dynamic = Reflect.field(playerSave, "destructableTypes");
			if (lDestructableType)
			{
				var destructableType:Dynamic;
				for (type in Reflect.fields(lDestructableType))
				{
					destructableType = Reflect.field(lDestructableType, type);
					var lElemType:DestructableType =
					{
						name:Reflect.field(destructableType, "destructableName"),
						softCurrencyCost:Std.parseInt(Reflect.field(destructableType,"softCurrencyCost")),
						skipHCCost:Std.parseInt(Reflect.field(destructableType, "skipCDcostHC")),
						destructionTime:Reflect.field(destructableType, "destructableTime"),
						width:Std.parseInt(Reflect.field(destructableType, "width")),
						height:Std.parseInt(Reflect.field(destructableType, "height"))
					}
					listDestructableTypes.set(lElemType.name, lElemType);
				}
			}

			var lDestructables:Dynamic = Reflect.field(playerSave, "destructable");

			for (instance in Reflect.fields(lDestructables))
			{
				var destructible:Dynamic = Reflect.field(lDestructables, instance);

				var lDestructible:Destructible = new Destructible(destructible.type);

				var lElement:Element =
				{
					instanceID:destructible.destructableId,
					type:"Destructible",
					width:0,
					height:0,
					x:Std.parseInt(destructible.x),
					y:Std.parseInt(destructible.y),
					globalX:Std.parseInt(destructible.globalX),
					globalY:Std.parseInt(destructible.globalY),
					regionX:Std.parseInt(destructible.regionX),
					regionY:Std.parseInt(destructible.regionY),
					layer:Std.parseInt(destructible.layer),
					mode:destructible.mode,
					assetName: destructible.type,
					softCurrency:listDestructableTypes.get(destructible.type).softCurrencyCost,
					dateEndBuilding:Date.fromString(destructible.endOfDestructionTime),
					dateStartBuilding:Date.fromString(destructible.destructionTime)
				}

				var lcurrentRegion:Region = World.getInstance().getRegion(lElement.regionX, lElement.regionY);

				lDestructible.localWidth = listDestructableTypes.get(lElement.assetName).width;
				lDestructible.localHeight = listDestructableTypes.get(lElement.assetName).height;

				lDestructible.init(lElement);
				lDestructible.start();

				lcurrentRegion.layers[lElement.layer].add(lDestructible);
				lcurrentRegion.layers[lElement.layer].container.addChild(lDestructible);

				lDestructible.position = IsoManager.modelToIsoView(new Point(lElement.x, lElement.y));

				PoolObject.elementList.set(lElement.instanceID, lElement);

			}

			var lBuildingTypes:Dynamic = Reflect.field(playerSave, "buildingTypes");
			if (lBuildingTypes)
			{
				var buildingType:Dynamic;
				for (type in Reflect.fields(lBuildingTypes))
				{
					buildingType = Reflect.field(lBuildingTypes, type);
					var lElemType:BuildingType =
					{
						SellingCost:Std.int(Reflect.field(buildingType, "SellingCost")),
						buildingName:Reflect.field(buildingType, "buildingName"),
						buildingTime:Date.fromString(Reflect.field(buildingType, "buildingTime")),
						category:Reflect.field(buildingType, "category"),
						description:Reflect.field(buildingType, "description"),
						energyCost:Std.int(Reflect.field(buildingType, "energyCost")),
						hardCurrencyCost:Std.int(Reflect.field(buildingType, "hardCurrencyCost")),
						id:Std.int(Reflect.field(buildingType, "id")),
						requiredPlayerLevel:Std.int(Reflect.field(buildingType, "requiredPlayerLevel")),
						ressourcesCost:Std.int(Reflect.field(buildingType, "ressourcesCost")),
						skipCDcostHC:Std.int(Reflect.field(buildingType, "skipCDcostHC")),
						softCurrencyCost:Std.int(Reflect.field(buildingType, "softCurrencyCost")),
						upgradeNumber:Std.int(Reflect.field(buildingType, "upgradeNumber")),
						levelUpgrade1:Std.int(Reflect.field(buildingType, "levelUpgrade1")),
						levelUpgrade2:Std.int(Reflect.field(buildingType, "levelUpgrade2")),
						levelUpgrade3:Std.int(Reflect.field(buildingType, "levelUpgrade3")),
						upgradeCost1:Std.int(Reflect.field(buildingType, "upgradeCost1")),
						upgradeCost2:Std.int(Reflect.field(buildingType, "upgradeCost2")),
						upgradeCost3:Std.int(Reflect.field(buildingType, "upgradeCost3")),
						upgradeTime1:Date.fromString(Reflect.field(buildingType, "upgradeTime1")),
						upgradeTime2:Date.fromString(Reflect.field(buildingType, "upgradeTime2")),
						upgradeTime3:Date.fromString(Reflect.field(buildingType, "upgradeTime3"))
					}
					listBuildingTypes.set(lElemType.buildingName, lElemType);
				}
			}

			//chargement des types d'alien
			var lTypes:Dynamic = Reflect.field(playerSave, "bufferTypes");
			AlienBuffer.loadTypes(lTypes);
			lTypes = Reflect.field(playerSave, "producerTypes");
			AlienProducer.loadTypes(lTypes);
			lTypes = Reflect.field(playerSave, "esthetiqueTypes");
			AlienEsthetique.loadTypes(lTypes);
			lTypes = Reflect.field(playerSave, "speFeatTypes");
			SpecialFeatureAliens.loadTypes(lTypes);

			//chargement des aliens
			var alienList:Dynamic = Reflect.field(playerSave, "aliens");

			if (alienList)
			{
				var lAlien:Dynamic;
				for (alien in Reflect.fields(alienList))
				{
					lAlien =  Reflect.field(alienList, alien);
					var lArray:Array<Dynamic> = getAlienArray(Reflect.field(lAlien, "type"));
					var lType:Dynamic = Alien.getAlienType(Reflect.field(lAlien, "name"), lArray);

					var lAlienElem:AlienElement =
					{
						idAlien:Reflect.field(lAlien, "idAlien"),
						idBuilding:Reflect.field(lAlien, "idBuilding"),
						mode:Reflect.field(lAlien, "mode"),
						name:Reflect.field(lAlien, "name"),
						type:Reflect.field(lAlien, "type"),
						nomPropre:Reflect.field(lAlien, "nomPropre"),
						stamina:Std.int(Reflect.field(lAlien, "stamina")),
						level:Std.int(Reflect.field(lAlien, "level")),
						startTime:Reflect.field(lAlien, "startTime"),
						endTime:Reflect.field(lAlien, "endTime"),
						carac:lType,
						idPlayer:Player.getInstance().id
					}
					Alien.alienElementList.push(lAlienElem);
				}
			}

			var lBuildings:Dynamic = Reflect.field(playerSave, "buildings");
			if (lBuildings)
			{
				for (id in Reflect.fields(lBuildings))
				{
					var building:Dynamic = Reflect.field(lBuildings, id);
					var currentRegion:Region;
					var lElement:Element =
					{
						instanceID:building.buildingId,
						type:building.type,
						width:0,
						height:0,
						x:Std.parseInt(building.x),
						y:Std.parseInt(building.y),
						globalX:Std.parseFloat(building.globalX),
						globalY:Std.parseFloat(building.globalY),
						regionX:Std.parseInt(building.regionX),
						regionY:Std.parseInt(building.regionY),
						layer:Std.parseInt(building.layer),
						mode:building.mode,
						levelUpGrade:Std.parseInt(building.currentLevel),
						dateEndBuilding:Date.fromString(building.buildingEnd),
						dateStartBuilding:Date.fromString(building.buildingStart)
					}

					currentRegion = World.getInstance().getRegion(lElement.regionX, lElement.regionY);

					var lBuilding:Building = cast (PoolManager.getFromPool(lElement.type), Building);
					lBuilding.init(lElement);
					lBuilding.start();

					currentRegion.layers[lElement.layer].add(lBuilding);
					currentRegion.layers[lElement.layer].container.addChild(lBuilding);

					lBuilding.position = IsoManager.modelToIsoView(new Point(lElement.x, lElement.y));

					PoolObject.elementList.set(lElement.instanceID, lElement);
				}
			}
			var lSchemaList:Dynamic = Reflect.field(playerSave, "schemaXenos");
			if (lSchemaList)
			{
				for (id in Reflect.fields(lSchemaList))
				{
					var schema:Dynamic = Reflect.field(lSchemaList, id);
					var lSchema:IncubatorSchema =
					{
						gene1:Std.parseInt(schema.gene1),
						gene2:Std.parseInt(schema.gene2),
						gene3:Std.parseInt(schema.gene3),
						tableXenos:schema.tableXenos,
						type: schema.type,
						gene1quant:Std.parseInt(schema.gene1quant),
						gene2quant:Std.parseInt(schema.gene2quant),
						gene3quant:Std.parseInt(schema.gene3quant),
						xenoName:schema.xenoName,
						decryptTime:schema.decryptTime
					}
					Incubator.listSchema.set(schema.id, lSchema);
				}
			}

			loadSchemaPlayer(playerSave);
		}
		CodexData.getInstance().listAllAlienTypesInCodex();

		var firstTime:Bool = playerSave.firstTime;
		/*if (firstTime)
		{
			Destructible.createFirstDestructible("DestructibleSkeleton", 15,15);
		}*/
		

	}

	public function loadFriendsInfo(pData:Dynamic):Void
	{
		friendsList = Json.parse(pData).friends;

		if (friendsList.length != null)
		{
			var lArray:Array<Int> = new Array<Int>();
			for (friend in friendsList)
			{
				if (friend.id != null) lArray.push(friend.id);
			}
			DataBaseAction.getInstance().getAlienFriends(lArray);
		}
	}

	public function loadFriendsAliensInfo(pData:Dynamic):Void
	{
		alienFriendsList = Json.parse(pData).aliens;
	}

	public function getAlienArray(pType:String):Array<Dynamic>
	{

		if (pType == "AlienBuffer") return AlienBuffer.bufferTypes;
		else if (pType == "AlienProducer") return AlienProducer.prodTypes;
		else if (pType == "AlienEsthetique") return AlienEsthetique.esthetiqueTypes;
		else if (pType == "AlienForeur") return SpecialFeatureAliens.speFeatTypes;
		else return null;
	}

	private function sortTilesInRegions():Void
	{
		for (lMap in World.getInstance().worldMap)
		{
			for (lRegion in lMap)
			{
				if (lRegion.isActive) lRegion.layers[1].container.children = IsoManager.sortTiles(lRegion.layers[1].container.children);
			}
		}
	}

	private function loadSchemaPlayer(pSave)
	{
		schemasList = pSave.playerSchemas;
		Player.getInstance().setSchema(getPlayerSchemaCount());

	}

	public function getPlayerSchemaCount(?pLockedSchemaOnly:Bool=false):Int
	{
		var counter:Int = 0;
		for (shema in schemasList)
		{
			if (pLockedSchemaOnly)
			{
				if (shema.isLocked == 1) counter++;
			}
			else counter++;
		}
		return counter;
	}

	public function addSchema(pSchemaID:Int):Void
	{
		var lSchema:Schemas = {
			idPlayer: Player.getInstance().id,
			idSchema: pSchemaID,
			isLocked: 1,
			startDecrypt:null,
			endDecrypt:null
		}

		DataBaseAction.getInstance().addSchema(pSchemaID);
			}
	
	

	public function getLockedSchemas():Array<Schemas>
	{
		var lArray:Array<Schemas> = new Array<Schemas>();
		for (schema in schemasList)
		{
			if (schema.isLocked == 1) lArray.push(schema);
		}
		return lArray;
	}

	public function getUnlockedSchemas():Array<Schemas>
	{
		var lArray:Array<Schemas> = new Array<Schemas>();
		for (schema in schemasList)
		{
			if (schema.isLocked == 0)
			{
				lArray.push(schema);
			}
		}
		return lArray;
	}


	
	public function translateSchema(pSchema:Schemas):Void
	{
		DataBaseAction.getInstance().getServerTime();

		DataBaseAction.getInstance().getSchemaTimeToDecrypt(pSchema.idSchema);
		
		/*var lSchema:Schemas = 
		{
			idPlayer: pSchema.idPlayer,
			idSchema: pSchema.idSchema,
			isLocked:pSchema.idSchema,
			startDecrypt: TimeManager.getInstance().timeServer,
			decrypTime
		}*/
		
		
		
		//lSchema.endDecrypt = DateTools.delta(currentSchema.startDecrypt, currentSchema.endDecrypt)
		
		//DataBaseAction.getInstance().startDecryptSchema(schema.idSchema);	
	}
	
	public function getSchemaTimeToDecrypt(pData:Dynamic):Dynamic->Void
	{
		return pData;
	}
	
}