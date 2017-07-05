package com.isartdigital.ruby.game;

import com.isartdigital.ruby.game.controller.Controller;
import com.isartdigital.ruby.game.controller.MouseController;
import com.isartdigital.ruby.game.controller.TouchController;
import com.isartdigital.ruby.game.player.MissionsManager;
import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.game.specialFeature.managers.SpecialFeatureAliens;
import com.isartdigital.ruby.game.specialFeature.managers.SFAliensManager;
import com.isartdigital.ruby.game.specialFeature.managers.SFGameManager;
import com.isartdigital.ruby.game.sprites.FlumpStateGraphic;
import com.isartdigital.ruby.game.sprites.elements.Building;
import com.isartdigital.ruby.game.sprites.elements.GameElement;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienPaddock;
import com.isartdigital.ruby.game.sprites.elements.aliens.Alien;
import com.isartdigital.ruby.game.world.Layer;
import com.isartdigital.ruby.game.world.MapInteractor;
import com.isartdigital.ruby.game.world.Region;
import com.isartdigital.ruby.game.world.UnlockButtonContainer;
import com.isartdigital.ruby.game.world.World;
import com.isartdigital.ruby.ui.CheatPanel;
import com.isartdigital.ruby.ui.UIManager;
import com.isartdigital.ruby.ui.ftue.FTUEManager;
import com.isartdigital.ruby.ui.hud.Hud;
import com.isartdigital.ruby.ui.items.switchItems.SwitchItem;
import com.isartdigital.ruby.ui.popin.ConfirmationPose;
import com.isartdigital.ruby.ui.popin.DailyReward;
import com.isartdigital.ruby.ui.popin.TimeBased;
import com.isartdigital.ruby.ui.popin.buyRegion.BuyRegion;
import com.isartdigital.ruby.ui.popin.contextual.ContextualPopin;
import com.isartdigital.ruby.ui.popin.incubator.Inseminator;
import com.isartdigital.ruby.ui.popin.translationCenter.TranslationCenter;
import com.isartdigital.ruby.ui.specialButtons.SlotButton;
import com.isartdigital.ruby.utils.ParticleManager;
import com.isartdigital.ruby.utils.RessourceEffect;
import com.isartdigital.services.deltaDNA.DeltaDNA;
import com.isartdigital.services.facebook.Facebook;
import com.isartdigital.services.monetization.Ads;
import com.isartdigital.services.monetization.Bank;
import com.isartdigital.services.monetization.Wallet;
import com.isartdigital.utils.Config;
import com.isartdigital.ruby.utils.ColorFilterManager;
import com.isartdigital.ruby.utils.SmartShaker;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.game.Camera;
import com.isartdigital.ruby.utils.Focus;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.clipping.ClippingManager;
import com.isartdigital.utils.game.filtersManagement.TwistFilterManager;
import com.isartdigital.utils.game.iso.IsoManager;
import com.isartdigital.utils.game.pooling.PoolManager;
import com.isartdigital.utils.game.pooling.PoolObject;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.save.DataBaseAction;
import com.isartdigital.utils.save.DataManager;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.system.DeviceCapabilities;
import haxe.Http;
import js.Browser;
import js.Lib;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject;
import pixi.core.graphics.Graphics;
import pixi.core.math.Point;
import pixi.core.renderers.webgl.managers.FilterManager;
import pixi.filters.twist.TwistFilter;
import pixi.interaction.EventTarget;
import pixi.loaders.Loader;


/**
 * Manager (Singleton) en charge de gérer le déroulement d'une partie
 * @author Mathieu ANTHOINE
 */
class GameManager
{

	/**
	 * instance unique de la classe GameManager
	 */
	private static var instance: GameManager;

	//taille des Tile
	public inline static var TILE_WIDTH:Int = 200;
	public inline static var TILE_HEIGHT:Int = 100;
	
	public var godMode:Bool = false;
	
	private var world:World;
	public var controller:Controller = cast(DeviceCapabilities.system != DeviceCapabilities.SYSTEM_DESKTOP ? TouchController.getInstance() : MouseController.getInstance(), Controller);
	public static inline var MODE_NORMAL:String = "Normal";
	public static inline var MODE_SPECIAL_FEATURE:String = "Spécial";
	public static inline var MODE_FTUE:String = "FTUE";
	
	public static var currentMode:String; 
	
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): GameManager
	{
		if (instance == null) instance = new GameManager();
		return instance;
	}

	private function new()
	{

	}

	public function start (): Void
	{
		

		setModeNormal();
		
		DeltaDNA.init("15182680138937855659639893914855", "15182686734822464480389743914855", "https://collect107252018r.deltadna.net/collect/api", "https://engage107252018r.deltadna.net", Std.string(Player.getInstance().id), Std.string(Player.getInstance().id + Std.string(Date.now().getTime())));
		
		GameStage.getInstance().getGameContainer().addChild(UnlockButtonContainer.getInstance().getUnlockContainer());
		//UnlockButtonContainer.getInstance().getUnlockContainer().position = GameStage.getInstance().getGameContainer().position;
		GameElement.JSON_CONFIG = GameLoader.getContent("caracBuilding.json");
		// demande au Manager d'interface de se mettre en mode "jeu"
		UIManager.getInstance().startGame();
		
		IsoManager.init(TILE_WIDTH, TILE_HEIGHT);
		

		//commenter la ligne suivante pour desactiver les intéraction avec la base de donnée !!!!
		//DataBaseAction.getInstance().activeData = true;

		world = World.getInstance();
		
		DataManager.getInstance().loadData();
		
		//Browser.getLocalStorage().clear();
		Region.sortAllContainer();
		

		//Controller.getInstance().init();
		if (DeviceCapabilities.system == DeviceCapabilities.SYSTEM_DESKTOP)
			initDesktop();
		else
			initMobile();

		//Spawner.getInstance().start();
		/////////////////////
		
		//Focus.getInstance().x = DeviceCapabilities.getScreenRect(GameStage.getInstance().getGameContainer()).width / 2;
		//Focus.getInstance().y = DeviceCapabilities.getScreenRect(GameStage.getInstance().getGameContainer()).height / 2;
		//Focus.getInstance().position = new Point(World.getInstance().getRegion(0, 0).regionContainer.x+ (TILE_WIDTH * Region.WIDTH) / 2, World.getInstance().getRegion(0, 0).regionContainer.y+ (TILE_HEIGHT * Region.HEIGHT) / 2);
		Focus.getInstance().position = new Point(GameStage.getInstance().getGameContainer().x, GameStage.getInstance().getGameContainer().y + (Region.HEIGHT * TILE_HEIGHT)/2);
		Camera.getInstance().setFocus(Focus.getInstance());
		Camera.getInstance().setTarget(GameStage.getInstance().getInfoBulleContainer());
		Camera.getInstance().setPosition();

		PoolManager.init(GameLoader.getContent("pool.json"));
		ClippingManager.getInstance().init(DeviceCapabilities.getScreenRect(GameStage.getInstance().getInfoBulleContainer()));
		MissionsManager.getInstance().init(GameLoader.getContent("missions.json"));
		for (paddock in AlienPaddock.alienPaddockList) cast(paddock.instance, AlienPaddock).getBuildingOnAera(true);
		// enregistre le GameManager en tant qu'écouteur de la gameloop principale
		Main.getInstance().on(EventType.GAME_LOOP, gameLoop);
		
		//pub
		//addAdsImage();
		//portefeuille
		//displayWallet();
		// bank
		//displayAccount();
		if (Player.getInstance().ftueSteps < FTUEManager.steps.length)
		{
			if (Player.getInstance().ftueSteps == 0) FTUEManager.nextStep();
			else 
			{
				FTUEManager.currentStep = Player.getInstance().ftueSteps + 1;
				FTUEManager.nextStep();
			}
		}
		
		//UIManager.getInstance().openPopin(DailyReward.getInstance());
		CheatPanel.getInstance().ingame();

		Controller.getInstance().init();
		for (popin in UIManager.getInstance().regionPopins) cast(popin, BuyRegion).displayCost();
		
		SoundManager.getSound("soundAtmosphere").play();
	}
	
	private function addAdsImage():Void{
		Ads.getImage(callBackAd);
	}
	
	private function callBackAd(pData:Dynamic):Void{
		if (pData == null) trace("erreur service");
		else if (pData.error != null) trace (pData.error);
		else trace(pData);
	}

	private function displayWallet():Void
	{
		Wallet.getMoney("coucou",callBackWallet);
	}
	
	private function callBackWallet(pData:Dynamic):Void{
		if (pData == null) trace("erreur service");
		else if (pData.error != null) trace (pData.error);
		else trace(pData);
	}
	
	private function displayAccount():Void
	{
		Bank.account(callBackBank);
	}
	
	private function callBackBank(pData:Dynamic):Void{
		if (pData == null) trace("erreur service");
		else if (pData.error != null) trace (pData.error);
		else trace(pData);
	}
	
	private function initDesktop():Void
	{
		MouseController.getInstance().init();
		//initStarsParticle();
	}

	private function initMobile():Void
	{
		TouchController.getInstance().init();
	}

	private function testMap(pX:Int, pY:Int, pObject:String):Void
	{
		var lRegion:Region = world.worldMap.get(pX).get(pY);
		var lLayer:Layer = lRegion.layers[0];
		var lBuilding:FlumpStateGraphic;
		var lPoint:Point;
		for (i in 0...lLayer.width)
		{
			for (j in 0...lLayer.width)
			{
				/*lBuilding = new FlumpStateGraphic(pObject);
				GameStage.getInstance().getGameContainer().addChild(lBuilding);
				lBuilding.start();
				lPoint = new Point(i + lRegion.width * lRegion.x, j + lRegion.height * lRegion.y);

				var lPoint2:Point = IsoManager.modelToIsoView(lPoint);
				lBuilding.x = lPoint2.x;
				lBuilding.y = lPoint2.y;*/

				lBuilding = new FlumpStateGraphic(pObject);
				lRegion = World.getInstance().getRegion(pX, pY);
				lPoint = new Point(i, j);
				//lPoint = new Point(i + lRegion.width * lRegion.x, j + lRegion.height * lRegion.y);
				var lPoint2:Point = IsoManager.modelToIsoView(lPoint);
				lBuilding.x = lPoint2.x;
				lBuilding.y = lPoint2.y;
				lBuilding.start();
				lRegion.regionContainer.addChild(lBuilding);
			}
		}
	}

	
/*	public function initStarsParticle():Void
	{
		RessourceEffect.starsParticle = ParticleManager.getInstance().createParticle("explosionStars2", ["stars1", "stars2", "stars3", "smoke03"], 10000);
		
		GameStage.getInstance().getGameContainer().addChild(RessourceEffect.starsParticle);

		
	}
	*/
	/**
	 * boucle de jeu (répétée à la cadence du jeu en fps)
	 */
	public function gameLoop (pEvent:EventTarget): Void
	{
		// le renderer possède une propriété plugins qui contient une propriété interaction de type InteractionManager
		// les instances d'InteractionManager fournissent un certain nombre d'informations comme les coordonnées globales de la souris
		MouseController.getInstance().doAction();
		ClippingManager.getInstance().clipping(DeviceCapabilities.getScreenRect(GameStage.getInstance().getGameContainer()));
		MapInteractor.getInstance().doAction();
		for (popin in UIManager.getInstance().regionPopins) cast(popin, BuyRegion).tooltip.count();
		Camera.getInstance().move();
		//Focus.getInstance().draw();
		TimeBased.getInstance().refreshText();
		ColorFilterManager.getInstance().doAction();
		Controller.getInstance().detectClicLength();
		
		for (i in 0...PoolObject.activeObjectList.length){
			if (PoolObject.activeObjectList[i] == null) continue;	
			PoolObject.activeObjectList[i].doAction();
		}
		
		for (j in 0...SFAliensManager.getInstance().activatedAlienList.length) 
		{
			if (SFAliensManager.getInstance().activatedAlienList[j] == null) continue;
			SFAliensManager.getInstance().activatedAlienList[j].doAction();
		}
		
		if (Inseminator.list.length > 0)
		{
			for (ins in Inseminator.list) ins.doAction();
		}
		
		if (TranslationCenter.getInstance().schemaInDecryptMode.length > 0)
		{
			for (schema in TranslationCenter.getInstance().schemaInDecryptMode) 
			{
				TranslationCenter.getInstance().doAction();
				
			}
		}
		ParticleManager.getInstance().update();
		SmartShaker.getInstance().doAction();
		
		if (SwitchItem.list != null)
				for (switchItem in SwitchItem.list)
					switchItem.setAsset();
					
		if (SlotButton.list != null)
			for (slot in SlotButton.list) {
				slot.invisibleGreySquare();
				slot.setAsset();
			}
		
	
		//TwistFilterManager.getInstance().doAction();
		
/*		initStarsParticle();
				RessourceEffect.starsParticle.position = MouseController.getInstance().getPosFrom(GameStage.getInstance().getGameContainer());*/

		
	}
	
	public function setModeNormal():Void
	{
		currentMode = MODE_NORMAL;
	}
	
	public function setModeSpecial():Void
	{
		currentMode = MODE_SPECIAL_FEATURE;
	}
	
	public function setModeFtue():Void
	{
		currentMode = MODE_FTUE;
	}
	
	public function getCurrentMode():String
	{
		return currentMode;
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void
	{
		Main.getInstance().off(EventType.GAME_LOOP,gameLoop);
		instance = null;
	}

}