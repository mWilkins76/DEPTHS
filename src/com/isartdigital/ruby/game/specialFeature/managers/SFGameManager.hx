package com.isartdigital.ruby.game.specialFeature.managers;
import com.isartdigital.ruby.game.controller.Controller;
import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.game.specialFeature.managers.SFGridManager.Vector3;
import com.isartdigital.ruby.game.specialFeature.managers.SFAliensManager;
import com.isartdigital.ruby.game.specialFeature.tiles.Tile;
import com.isartdigital.ruby.game.specialFeature.tiles.classes.Clue;
import com.isartdigital.ruby.game.specialFeature.tiles.classes.HardBrick;
import com.isartdigital.ruby.game.specialFeature.tiles.classes.SpecialFeatureItem;
import com.isartdigital.ruby.game.specialFeature.tiles.classes.Lava;
import com.isartdigital.ruby.game.sprites.elements.ElementType;
import com.isartdigital.ruby.game.sprites.elements.aliens.Alien;
import com.isartdigital.ruby.game.sprites.elements.aliens.AlienElement;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.translationClass.Schemas;
import com.isartdigital.ruby.ui.UIManager;
import com.isartdigital.ruby.ui.hud.Hud;
import com.isartdigital.ruby.ui.popin.RewardNotifications;
import com.isartdigital.ruby.ui.popin.building.datas.Missions;
import com.isartdigital.ruby.utils.RessourcesEffectManager;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.GameObject;
import com.isartdigital.utils.game.clipping.IClippable.Element;
import com.isartdigital.utils.game.pooling.PoolManager;
import com.isartdigital.utils.game.pooling.PoolObject;
import com.isartdigital.ruby.utils.ColorFilterManager;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.save.DataBaseAction;
import com.isartdigital.utils.save.DataManager;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.system.DeviceCapabilities;
import com.isartdigital.utils.ui.smart.SmartComponent;
import haxe.Json;
import pixi.core.display.Container;
import pixi.core.math.Point;




/**
 * ...
 * @author Julien Fournier
 */
class SFGameManager 
{
	
	/**
	 * instance unique de la classe SpecialFeatureManager
	 */
	private static var instance: SFGameManager;

	public static inline var TOTAL_MAPS:Int = 78;

	public var missionParam:Missions;
	public var currentMap:Int = 1;
	public var rewardHC:Int;
	public var rewardSC:Int;
	public var rewardGene1:Int;
	public var rewardGene2:Int;
	public var rewardGene3:Int;
	public var rewardGene4:Int;
	public var rewardGene5:Int;
	public var rewardSchema:Int = 0;
	public var rewardDarkMatter:Int;
	
	public var tileContainer:SmartComponent;
	public var globalContainer:Container = new Container();
	public var particleContainer:Container = new Container();
	public var rewardContainer:Container = new Container();
	public var alienContainer:Container = new Container();
	public var wallsContainer:Container = new Container();
	public var skillContainer:Container = new Container();
	public var moveContainer:Container = new Container();	
	public var blocsContainer:Container = new Container();	
	public var ressourcesContainer:Container = new Container();
	public var alienSpawnNumber:Int;
	
	public var collectedReward:Reward;
	
	public var xenoList:Array<AlienElement> = [];


	public var isInit:Bool = false;
		

	

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): SFGameManager {
		if (instance == null) instance = new SFGameManager();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		
	}
	
	

	/**
	 * Initialisation de la spéciale feature
	 * (init de la current map, des aliens, génération de la grille, du hud, ...)
	 * @param	pMission numéro de la map à charger
	 * @param	pXenoList liste d'alien à charger dans la special feature
	 */
	public function init(pMission:Missions, pXenoList:Array<AlienElement>):Void
	{
		initReward();
		GameManager.getInstance().setModeSpecial();
		SoundManager.getSound("soundAtmosphere").stop();
		SoundManager.getSound("soundMusicSpecialFeature").play();
		missionParam = pMission;
		xenoList = pXenoList;
		currentMap = Std.parseInt(missionParam.map);
		alienSpawnNumber = missionParam.alienSpawner;

		
		if (isInit) return;
		else isInit = true;

		UIManager.getInstance().closeAllPopins();
		UIManager.getInstance().closeHud();
		UIManager.getInstance().openScreen(SpecialFeatureScreen.getInstance());
				
		SFGridManager.getInstance().generateGrid();
		SFAliensManager.getInstance().initAliensList(pXenoList);
		SFAliensManager.getInstance().instanciateAlien();
		SpecialFeatureScreen.getInstance().initContainers();
		

		tileContainer = SpecialFeatureScreen.getInstance().tilesContainer;
		var tileContainerPosition:Point = new Point
				(
					tileContainer.position.x - (tileContainer.width / 2) + (SFGridManager.CELL_WIDTH)-5, 
					tileContainer.position.y - (tileContainer.height/ 2) + (SFGridManager.CELL_HEIGHT / 2)-5
				);
				
		rewardContainer.position = tileContainerPosition;
		particleContainer.position = tileContainerPosition;
		alienContainer.position = tileContainerPosition;		
		wallsContainer.position = tileContainerPosition;		
		skillContainer.position = tileContainerPosition;		
		moveContainer.position = tileContainerPosition;		
		blocsContainer.position = tileContainerPosition;		
		ressourcesContainer.position = tileContainerPosition;
		
		tileContainer.addChild(ressourcesContainer);
		tileContainer.addChild(blocsContainer);	
		tileContainer.addChild(moveContainer);	
		tileContainer.addChild(skillContainer);		
		tileContainer.addChild(wallsContainer);
		tileContainer.addChild(particleContainer);
		tileContainer.addChild(alienContainer);
		tileContainer.addChild(rewardContainer);
		
		tileContainer.interactive = true;

		SpecialFeatureScreen.getInstance().initHud();
		SpecialFeatureScreen.getInstance().updateRessourceHud();
		
	}
	
	public function initReward():Void
	{
		collectedReward = {
		
			hc:0,
			sc:0,
			gene1:0,
			gene2:0,
			gene3:0,
			gene4:0,
			gene5:0,
			schema:0,
			darkMatter:0
			
		}
	}
	
	
	public function checkIfAliensStillHasStamina():Bool
	{
		SpecialFeatureScreen.getInstance().closeFlag = true;
		var haveStamina:Bool = false;
		for (alien in SFAliensManager.getInstance().activatedAlienList)
		{
			//alien.stamina = 0;
			if (alien.stamina > 0) {
				haveStamina = true;
				return haveStamina;
			}
			else
			{
				haveStamina = false;
			}
		}
		return haveStamina;
	}
	
	public function openEndMissionPoppin():Void
	{
		RewardNotifications.getInstance().initMissionEnd(collectedReward, xenoList);
		UIManager.getInstance().openPopin(RewardNotifications.getInstance());
		SoundManager.getSound("soundMissionEnd").play();
	
	}

	/**
	 * Donne des ressources au player et update le hud
	 * @param	pRewardType
	 */
	public function giveRewardToPlayer(pRewardType:String):Void
	{
		if (pRewardType == ElementType.ITEM_GENEONE)
		{
			rewardGene1 = Std.int(missionParam.rewards.gene1);			
			Player.getInstance().changePlayerValue(rewardGene1, "gene1");
			collectedReward.gene1 += rewardGene1;
		}
		if (pRewardType == ElementType.ITEM_GENETWO)
		{
			rewardGene2 = Std.int(missionParam.rewards.gene2);			
			Player.getInstance().changePlayerValue(rewardGene2, "gene2");
			collectedReward.gene2 += rewardGene2;
		}
		if (pRewardType == ElementType.ITEM_GENETHREE)
		{
			rewardGene3 = Std.int(missionParam.rewards.gene3);
			Player.getInstance().changePlayerValue(rewardGene3, "gene3");
			collectedReward.gene3 += rewardGene3;
		}
		if (pRewardType == ElementType.ITEM_GENEFOUR)
		{
			rewardGene4 = Std.int(missionParam.rewards.gene4);			
			Player.getInstance().changePlayerValue(rewardGene4, "gene4");
			collectedReward.gene4 += rewardGene4;
		}
		if (pRewardType == ElementType.ITEM_GENEFIVE)
		{
			rewardGene5 = Std.int(missionParam.rewards.gene5);
			Player.getInstance().changePlayerValue(rewardGene5, "gene5");
			collectedReward.gene5 += rewardGene5;
		}
		if (pRewardType == ElementType.ITEM_DARKMATTER)
		{
			rewardDarkMatter = Std.int(missionParam.rewards.darkMatter);
			Player.getInstance().changePlayerValue(rewardDarkMatter, "ressource");
			collectedReward.darkMatter += rewardDarkMatter;
		}
		if (pRewardType == ElementType.ITEM_HC)
		{
			rewardHC = Std.int(missionParam.rewards.hc);
			Player.getInstance().changePlayerValue(rewardHC, "hardCurrency");  
			collectedReward.hc += rewardHC;
		}
		if (pRewardType == ElementType.ITEM_SC)
		{
			rewardSC = Std.int(missionParam.rewards.sc);
			Player.getInstance().changePlayerValue(rewardSC, "softCurrency"); 
			collectedReward.sc += rewardSC;
		}
		if (pRewardType == ElementType.ITEM_BLUEPRINT)
		{
			giveLockedSchema();
			SpecialFeatureScreen.getInstance().playerSchema++;
			collectedReward.schema++;	 
		}
		SpecialFeatureScreen.getInstance().updateRessourceHud();
	}


	public function giveLockedSchema():Void
	{
		var schemaJson:Dynamic = GameLoader.getContent("schemas.json");
		DataManager.getInstance().addSchema(Std.int(Reflect.field(schemaJson, Std.string(currentMap))));
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}