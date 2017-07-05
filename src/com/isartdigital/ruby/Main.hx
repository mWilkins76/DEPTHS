package com.isartdigital.ruby;

import com.isartdigital.ruby.game.GameManager;
import com.isartdigital.ruby.game.controller.MouseController;
import com.isartdigital.ruby.game.player.MissionsManager;
import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.game.sprites.elements.destructible.Destructible;
import com.isartdigital.ruby.preloadgame.LoadingBar;
import com.isartdigital.ruby.preloadgame.PreloadMiniGame;
import com.isartdigital.ruby.ui.GraphicLoader;
import com.isartdigital.ruby.ui.items.DrillingXenoItem;
import com.isartdigital.ruby.ui.items.switchItems.SpecialFeatureSwitchSkill;

import com.isartdigital.ruby.ui.items.switchItems.UpgradeCenterSwitchItem;
import com.isartdigital.ruby.ui.items.switchItems.XenosPanelSwitchItem;
import com.isartdigital.ruby.ui.items.switchItems.BuildingMenuSwitchTab;
import com.isartdigital.ruby.ui.items.DrillingFriendItem;
import com.isartdigital.ruby.ui.items.switchItems.DrillingButtonSwitchItem;
import com.isartdigital.ruby.ui.items.switchItems.MissionSwitchItem;
import com.isartdigital.ruby.ui.items.switchItems.SwitchItem;
import com.isartdigital.ruby.ui.ftue.FTUEManager;
import com.isartdigital.ruby.ui.hud.XpBar;
import com.isartdigital.ruby.ui.hud.XpBar;
import com.isartdigital.ruby.ui.items.switchItems.XenoSlotSwitchItem;
import com.isartdigital.ruby.ui.items.switchItems.XenoSocialSwitchItem;
import com.isartdigital.ruby.ui.popin.IsartPoints;
import com.isartdigital.ruby.ui.popin.buyRegion.RegionSwitch;
import com.isartdigital.ruby.ui.popin.enclos.EnclosSwitchItem;
import com.isartdigital.ruby.ui.popin.incubator.GeneButton;
import com.isartdigital.ruby.ui.popin.incubator.GeneSpot;
import com.isartdigital.ruby.ui.items.switchItems.BuildingMenuSwitchItem;
import com.isartdigital.ruby.ui.popin.building.datas.BuildingMenuData;
import com.isartdigital.ruby.ui.popin.codex.CodexData;
import com.isartdigital.ruby.ui.popin.incubator.Inseminator;
import com.isartdigital.ruby.ui.popin.incubator.TimerIncubator;
import com.isartdigital.ruby.ui.popin.shop.ShopItem;
import com.isartdigital.ruby.ui.popin.shop.ShopItemBig;
import com.isartdigital.ruby.ui.popin.shop.ShopItemMedium;
import com.isartdigital.ruby.ui.items.switchItems.ShopSwitchTab;
import com.isartdigital.ruby.ui.popin.shop.datas.ShopData;
import com.isartdigital.ruby.game.specialFeature.tiles.Tile;
import com.isartdigital.ruby.game.specialFeature.managers.SFGameManager;
import com.isartdigital.ruby.ui.popin.upgradeCenter.TankUpgrade;
import com.isartdigital.ruby.ui.specialButtons.Textbutton;
import com.isartdigital.ruby.utils.TimeManager;
import com.isartdigital.services.deltaDNA.DeltaDNA;
import com.isartdigital.utils.system.Localization;
import com.isartdigital.utils.system.Localization;
import haxe.Http;
import haxe.Json;
import js.html.CanvasElement;
import pixi.core.math.Point;

import com.isartdigital.utils.save.DataBaseAction;

import com.isartdigital.ruby.ui.hud.Hud;
import com.isartdigital.ruby.ui.screens.TitleCard;
import com.isartdigital.ruby.ui.UIManager;
import com.isartdigital.services.facebook.Facebook;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.events.LoadEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.GameStageScale;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.game.factory.MovieClipAnimFactory;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.system.DeviceCapabilities;
import haxe.Timer;
import js.Browser;
import js.Lib;
import pixi.core.display.Container;
import pixi.core.renderers.Detector;
import pixi.core.renderers.webgl.WebGLRenderer;
import eventemitter3.EventEmitter;
import pixi.interaction.EventTarget;
import pixi.loaders.Loader;

/**
 * Classe d'initialisation et lancement du jeu
 * @author Mathieu ANTHOINE
 */

class Main extends EventEmitter
{

	private static inline var FPS:UInt = 16; //Math.floor(1000/60);
	
	public var frame(default, null):Int = 10;
	
	private var isLoaded:Bool = false;
	private var isLogged:Bool = false;
	public var isAnimLoadingDone:Bool = false;


	
	/**
	 * chemin vers le fichier de configuration
	 */
	private static var configPath:String = "config.json";

	/**
	 * instance unique de la classe Main
	 */
	private static var instance: Main;

	/**
	 * renderer (WebGL ou Canvas)
	 */
	public var renderer:WebGLRenderer;

	/**
	 * Element racine de la displayList
	 */
	public var stage:Container;

	/**
	 * initialisation générale
	 */
	private static function main ():Void
	{
		Main.getInstance();
	}

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Main
	{
		if (instance == null) instance = new Main();
		return instance;
	}

	/**
	 * création du jeu et lancement du chargement du fichier de configuration
	 */
	private function new ()
	{

		super();
		var lOptions:RenderingOptions = { };
		//lOptions.antialias = true;
		//lOptions.autoResize = true;
		lOptions.backgroundColor = 0x0d3561;
		//lOptions.resolution = 1;
		//lOptions.transparent = false;
		//lOptions.preserveDrawingBuffer (pour dataToURL)
		
		DeviceCapabilities.scaleViewport();
		
		renderer = Detector.autoDetectRenderer(DeviceCapabilities.width, DeviceCapabilities.height,lOptions);
		//renderer.roundPixels = true;

		Browser.document.body.appendChild(renderer.view);

		stage = new Container();

		var lConfig:Loader = new Loader();
		configPath += "?" + Date.now().getTime();
		lConfig.add(configPath);
		lConfig.once(LoadEventType.COMPLETE, preloadAssets);

		Facebook.onLogin = onLogin;
		Facebook.load("1007819322696165");
		//isLogged = true;
		//DataBaseAction.getInstance().connexionPlayer("10154767559052348", "Mike");
		
		
		lConfig.load();
		
	}
	
	private static function importClasses():Void {
		ShopItem;
		BuildingMenuSwitchItem;
		ShopItemMedium;
		ShopItemBig;
		SwitchItem;
		ShopSwitchTab;
		DrillingXenoItem;
		DrillingFriendItem;
		DrillingButtonSwitchItem;
		MissionSwitchItem;
		XenoSocialSwitchItem;
		XenosPanelSwitchItem;
		XenoSlotSwitchItem;
		BuildingMenuSwitchTab;
		GeneButton;
		GeneSpot;
		Inseminator;
		XpBar;
		PreloadMiniGame; 
		Textbutton;
		TankUpgrade;
		UpgradeCenterSwitchItem;
		EnclosSwitchItem;
		RegionSwitch;
		TimerIncubator;
		IsartPoints;
		SpecialFeatureSwitchSkill;
	}

	/**
	 * charge les assets graphiques du preloader principal
	 */
	private function preloadAssets(pLoader:Loader):Void
	{

		// initialise les paramètres de configuration
		Config.init(Reflect.field(pLoader.resources,configPath).data);

		// Active le mode debug
		if (Config.debug) Debug.getInstance().init();
		// défini l'alpha des Boxes de collision
		if (Config.debug && Config.data.boxAlpha != null) StateGraphic.boxAlpha = Config.data.boxAlpha;
		// défini l'alpha des anims
		if (Config.debug && Config.data.animAlpha != null) StateGraphic.animAlpha = Config.data.animAlpha;

        DeviceCapabilities.init(1, 0.75, 0.5);
		// initialise le GameStage et défini la taille de la safeZone
		if (DeviceCapabilities.system == DeviceCapabilities.SYSTEM_DESKTOP)
		{
			GameStage.getInstance().scaleMode = GameStageScale.NO_SCALE;
			untyped DeviceCapabilities.textureRatio = 0.5;
			untyped DeviceCapabilities.textureType = DeviceCapabilities.TEXTURE_LD;
		}
		else {
			GameStage.getInstance().scaleMode = GameStageScale.SHOW_ALL;
		}

		// initialise le GameStage et défini la taille de la safeZone
		GameStage.getInstance().init(render,2048, 1366, false,false, true, true, true);
		//GameStage.getInstance().init(render,4080, 2700, false ,false, true, true, true);

		// Ajoute le GameStage au stage
		stage.addChild(GameStage.getInstance());

		// ajoute Main en tant qu'écouteur des évenements de redimensionnement
		Browser.window.addEventListener(EventType.RESIZE, resize);
		resize();

		// lance le chargement des assets graphiques du preloader
		var lLoader:GameLoader = new GameLoader();
		lLoader.addAssetFile("ld/bulles/library.json");
		lLoader.addAssetFile("black_bg.png");
		lLoader.addAssetFile("preload.png");
		lLoader.addAssetFile("preload_bg.png");
		lLoader.addAssetFile("Curseur.png");
		//lLoader.addAssetFile("SplashScreen.png");

		lLoader.once(LoadEventType.COMPLETE, loadAssets);
		lLoader.load();
		PreloadMiniGame.getInstance().start();
		
	}

	/**
	 * lance le chargement principal
	 */
	private function loadAssets (pLoader:GameLoader): Void
	{
		var lLoader:GameLoader = new GameLoader();
		var levelMax:Int = SFGameManager.TOTAL_MAPS + 1;
		var regionsDestructiblesMax:Int = Destructible.totalConfig;
		
		//FileSystem
		lLoader.addTxtFile("../localization/localisation.json");
		lLoader.addTxtFile("boxes.json");
		lLoader.addTxtFile("pool.json");
		lLoader.addTxtFile("caracBuilding.json");
		lLoader.addTxtFile("descriptionAlien.json");
		lLoader.addTxtFile("Region.json");
		lLoader.addTxtFile("schemas.json");
		lLoader.addSoundFile("sounds.json");
		lLoader.addTxtFile("FTUE.json");
		lLoader.addTxtFile("Shop.json");
		lLoader.addTxtFile("BuildingMenuData.json");
		lLoader.addTxtFile("xenosCodex.json");
		lLoader.addTxtFile("../balance/alienBalance.json");
		lLoader.addTxtFile("missions.json");
		
		//lLoader.addTxtFile("Map1.json");
		for (i in 1...regionsDestructiblesMax)
		{
			lLoader.addTxtFile("RegionsJSON/Config" + i + ".json");
			Destructible.arrayConfigDestructible.push("RegionsJSON/Config" + i + ".json");
		}
		for (i in 1...levelMax) 
		{	
			lLoader.addTxtFile("specialFeatureMaps/Map"+i+".json");
		}
		
		lLoader.addAssetFile("alpha_bg.png");
		lLoader.addAssetFile("sft.png");
		lLoader.addAssetFile("TitleCard_bg.png");
		lLoader.addAssetFile("Confirm.png");
		lLoader.addAssetFile("ftue_bg.png");
		lLoader.addAssetFile("ftue2_bg.png");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/placeholder/library.json");
		
		
		//lLoader.addAssetFile(DeviceCapabilities.textureType+"/Buildings/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/Buildings_Alien/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/Buildings_Drilling/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/Buildings_Urban/library.json");		
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/Buildings_Cosmetic/library.json");		
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/BuildingMenu/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/BuyRegion/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/TutoSpecialFeature/library.json");
		
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/Aliens_Producers/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/Aliens_foreurs/library.json");
		
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/BuildingContextualMenu/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/CentreForage/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/Codex/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/ItemAsset/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/TabAsset/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/Missionthumbnail/library.json");
		//lLoader.addAssetFile(DeviceCapabilities.textureType+"/ConfirmationPose/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/ConfirmationPose_02/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/Deplacement/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/Destruction/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/DailyReward/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/Enclos/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/Friendlist/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/HUD/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/Incubator/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/InfosBatiments/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/Shop/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/TeamSelect/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/TimeBased/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/TranslationCenter/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/XenoPage/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/XenosPanel/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/Background/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/Destructible/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/FTUE/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/Settings/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/PubImage/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/PubVideo/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/UpgradeCenter/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/YesNoPose/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/RewardNotification/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/WarFog/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/IsartPoints/library.json");
		
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/RessourcesEffect/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/SpecialFeatureScreen/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/SpecialFeatureTiles/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/SpecialFeatureAliens/library.json");
		
		// PARTICLES ASSET
		lLoader.addAssetFile("particles/assets/bubble.png");
		lLoader.addAssetFile("particles/assets/smoke01.png");
		lLoader.addAssetFile("particles/assets/smoke02.png");
		lLoader.addAssetFile("particles/assets/smoke03.png");
		lLoader.addAssetFile("particles/assets/sparks1.png");
		lLoader.addAssetFile("particles/assets/sparks2.png");
		lLoader.addAssetFile("particles/assets/sparks3.png");
		lLoader.addAssetFile("particles/assets/bloc1.png");
		lLoader.addAssetFile("particles/assets/bloc2.png");
		lLoader.addAssetFile("particles/assets/bloc3.png");
		lLoader.addAssetFile("particles/assets/bloc4.png");
		lLoader.addAssetFile("particles/assets/stars1.png");
		lLoader.addAssetFile("particles/assets/stars2.png");
		lLoader.addAssetFile("particles/assets/stars3.png");
		
		// PARTICLES JSON
		lLoader.addTxtFile("particles/json/bubble.json");
		lLoader.addTxtFile("particles/json/smoke.json");
		lLoader.addTxtFile("particles/json/ressources.json");
		lLoader.addTxtFile("particles/json/bomb.json");
		lLoader.addTxtFile("particles/json/trail.json");
		lLoader.addTxtFile("particles/json/trail2.json");
		lLoader.addTxtFile("particles/json/trail3.json");
		lLoader.addTxtFile("particles/json/bubbleCircle.json");
		lLoader.addTxtFile("particles/json/dig.json");
		lLoader.addTxtFile("particles/json/starsTrail.json");
		lLoader.addTxtFile("particles/json/explosionStars.json");
		lLoader.addTxtFile("particles/json/explosionStars2.json");
		lLoader.addTxtFile("particles/json/destroy.json");
		
		//lLoader.addAssetFile(DeviceCapabilities.textureType+"/bulles/library.json");
		lLoader.addFontFile("fonts.css");

		lLoader.on(LoadEventType.PROGRESS, onLoadProgress);
		lLoader.once(LoadEventType.COMPLETE, onLoadComplete);

		// affiche l'écran de préchargement
		UIManager.getInstance().openScreen(LoadingBar.getInstance());

		Browser.window.requestAnimationFrame(gameLoop);

		lLoader.load();

	}

	/**
	 * transmet les paramètres de chargement au préchargeur graphique
	 * @param	pEvent evenement de chargement
	 */
	private function onLoadProgress (pLoader:GameLoader): Void
	{
		LoadingBar.getInstance().update(pLoader.progress);
	}

	/**
	 * initialisation du jeu
	 * @param	pEvent evenement de chargement
	 */
	private function onLoadComplete (pLoader:GameLoader):Void
	{
		//Cell.setJson("Map" + SpecialFeatureManager.getInstance().currentLevel + ".json");
		pLoader.off(LoadEventType.PROGRESS, onLoadProgress);

		// transmet à MovieClipAnimFactory la description des planches de Sprites utilisées par les anim MovieClip des instances de StateGraphic
		//MovieClipAnimFactory.addTextures(GameLoader.getContent("Template.json"));

		// transmet au StateGraphic la description des boxes de collision utilisées par les instances de StateGraphic
		StateGraphic.addBoxes(GameLoader.getContent("boxes.json"));

		// affiche le bouton FullScreen quand c'est nécessaire
		DeviceCapabilities.displayFullScreenButton();
		//initialisation de la localisation et de la langue
		Localization.init(GameLoader.getContent("../localization/localisation.json"), "fr");
		//Ouvre la TitleClard
		isLoaded = true;
		
		if (isLogged && isAnimLoadingDone) launchGame();
	}
	
	public function verifyLaunch():Void {
	
		if (isLogged && isLoaded) launchGame();
	}
	
	private function launchGame():Void {
	
		PreloadMiniGame.getInstance().destroy();
		FTUEManager.init(GameLoader.getContent("FTUE.json"));
		ShopData.getInstance().init(GameLoader.getContent("Shop.json"));
		MissionsManager.getInstance().init(GameLoader.getContent("missions.json"));
		BuildingMenuData.getInstance().init(GameLoader.getContent("BuildingMenuData.json"));		
		DeltaDNA.init("15182680138937855659639893914855", "15182686734822464480389743914855", "https://collect107252018r.deltadna.net/collect/api", "https://engage107252018r.deltadna.net", Std.string(Player.getInstance().id), Std.string(Player.getInstance().id + Std.string(Date.now().getTime())));
		sendEventConnect();
		GameManager.getInstance().start();
	}
	
	private function sendEventConnect():Void
	{
		var lEvent:Dynamic ={
			eventName:"newPlayer",
			userID:Player.getInstance().idFb,
			sessionID:Player.getInstance().idFb + TimeManager.getInstance().timeServer.getTime(),
			eventParams: {
				platform: "PC_CLIENT"
			}
		};

		//TODO: remplacer collect--- par l'url de Collect et --- par la clé Dev ou Live
		var lRequest:Http = new Http("https://collect107252018r.deltadna.net/collect/api/15182680138937855659639893914855");
		lRequest.addHeader("Content-Type","application/json");
		lRequest.setPostData(Json.stringify(lEvent));
		/*lRequest.onData = onData;
		lRequest.onError = onError;*/
		lRequest.request(true);
		trace("eventConnexionPlayer");
	}
	
	public function onSaveLoaded():Void
	{
		isLogged = true;
		if (isLoaded) {
			PreloadMiniGame.getInstance().destroy();
			FTUEManager.init(GameLoader.getContent("FTUE.json"));
			ShopData.getInstance().init(GameLoader.getContent("Shop.json"));
			
			BuildingMenuData.getInstance().init(GameLoader.getContent("BuildingMenuData.json"));
			GameManager.getInstance().start();
		}
	}

	private function onLogin():Void
	{
		
		
		//Facebook.api(Facebook.uid + "?fields=first_name", callBackApi);
		// Au passage ici on voit qu'on accède pas à toutes les infos parce qu'on est pas autorisés (https://developers.facebook.com/docs/graph-api/reference/user/)
		//Facebook.api(Facebook.uid, { fields: "first_name,last_name,favorite_athletes"}, callBackApi);
		
		//Facebook.api(Facebook.uid+"/friends", callBackApi);
		//Facebook.api(Facebook.uid+"/invitable_friends", callBackApi);
		
		//Facebook.ui( { method: 'share', href: 'https://developers.facebook.com/docs/' },callBackUI );
		//Facebook.ui( { method: 'apprequests', message: 'Yeah \\o/' },callBackUI );
		
		/*
		Facebook.ui(
			{
				method: 'share_open_graph',
				action_type: 'og.shares',
				action_properties: Json.stringify({
					object:	{
						'og:url':'https://developers.facebook.com/docs/',
						'og:title': 'Documentation Facebook',
						'og:description': 'trop bien !',
						'og:image':'http://www.pixelstalk.net/wp-content/uploads/2016/04/Download-desktop-spongebob-wallpaper-HD-620x388.jpg'
					}
				})
			},
			callBackUI);
		*/
	
		/*
		Facebook.ui(
			{
				method: 'share_open_graph',
				action_type: 'og.likes',
				action_properties: Json.stringify({
					object:'https://developers.facebook.com/docs/',
				})
			},
			callBackUI);
		*/
		
		Facebook.api(Facebook.uid + "?fields=first_name", callBackApi);
		Facebook.api(Facebook.uid + "?fields=email", callBackEmail);
		Facebook.api(Facebook.uid+"/friends", callBackFriends);
	}
	
	private function callBackApi(pData:Dynamic):Void
	{
		if (pData == null) trace("erreur facebook.api");
		else if (pData.error != null) trace (pData.error);
		else {
			//commenter la ligne suivante pour desactiver les intéraction avec la base de donnée !!!!
			DataBaseAction.getInstance().activeData = true;
			DataBaseAction.getInstance().connexionPlayer(Facebook.uid, pData.first_name);
		}
	}
	
	private function callBackEmail(pData:Dynamic):Void
	{
		if (pData == null) trace("erreur facebook.api email");
		else if (pData.error != null) trace (pData.error);
		else {
			Player.getInstance().email = Reflect.field(pData, "email");
		}
	}
	
	private function callBackFriends(pData:Dynamic):Void
	{
		if (pData == null) trace("erreur friends Api");
		else if (pData.error_message != null) trace (pData.error_message);
		else 
		{
			var lArray:Array<Dynamic> = new Array<Dynamic>();
			var lFriends:Dynamic = Reflect.field(pData, "data");
			for (friend in Reflect.fields(lFriends))
			{
				lArray.push(Reflect.field(Reflect.field(lFriends, friend), "id"));
			} 
			var lFriendsID:Dynamic = Json.stringify(lArray);
			DataBaseAction.getInstance().getFriends(lFriendsID);
		}		
	}
		
	private function callBackUI(pData:Dynamic):Void
	{
		if (pData == null) trace("erreur facebook.ui");
		else if (pData.error_message != null) trace (pData.error_message);
		else 
		{
			trace(pData);
		}
	}
	
	/**
	 * game loop
	 */
	private function gameLoop(pID:Float):Void
	{		
		//Timer.delay(gameLoop, FPS);
		Browser.window.requestAnimationFrame(gameLoop);
		
		render();
		emit(EventType.GAME_LOOP);

	}

	/**
	 * Ecouteur du redimensionnement
	 * @param	pEvent evenement de redimensionnement
	 */
	public function resize (pEvent:EventTarget = null): Void
	{
		renderer.resize(DeviceCapabilities.width, DeviceCapabilities.height);
		GameStage.getInstance().resize();
	}

	/**
	 * fait le rendu de l'écran
	 */
	private function render (): Void
	{
		//renderer.render(stage);
		if (frame++ % 2 == 0){
			renderer.render(stage);
		}
		else{
			GameStage.getInstance().updateTransform();
		}
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void
	{
		Browser.window.removeEventListener(EventType.RESIZE, resize);
		instance = null;
	}

}