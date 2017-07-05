package com.isartdigital.ruby.ui.hud;

import com.isartdigital.ruby.game.Spawner;
import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.game.sprites.FlumpStateGraphic;
import com.isartdigital.ruby.game.sprites.elements.ElementType;
import com.isartdigital.ruby.game.world.MapInteractor;
import com.isartdigital.ruby.ui.ftue.FTUEManager;
import com.isartdigital.ruby.ui.popin.ConfirmationPose;
import com.isartdigital.ruby.ui.popin.DailyReward;
import com.isartdigital.ruby.ui.popin.Friendlist;
import com.isartdigital.ruby.ui.popin.Settings;
import com.isartdigital.ruby.ui.popin.XenosPanel;
import com.isartdigital.ruby.ui.popin.contextual.YesNoPose;
import com.isartdigital.ruby.ui.popin.contextual.BuildingContextualMenu;
import com.isartdigital.ruby.ui.popin.enclos.Enclos;
import com.isartdigital.ruby.ui.popin.TimeBased;
import com.isartdigital.ruby.ui.popin.XenoPage;
import com.isartdigital.ruby.ui.popin.shop.Shop;
import com.isartdigital.ruby.ui.popin.building.BuildingMenu;
import com.isartdigital.ruby.ui.popin.codex.Codex;
import com.isartdigital.ruby.ui.screens.PubImage;
import com.isartdigital.ruby.ui.screens.PubVideo;
import com.isartdigital.ruby.ui.screens.SmartScreenRegister;
import com.isartdigital.utils.Config;
import com.isartdigital.ruby.utils.ColorFilterManager;
import com.isartdigital.ruby.utils.ColorFilterManager.ColorFilterParams;
import com.isartdigital.ruby.utils.SmartShaker;
import com.isartdigital.ruby.utils.SmartShaker.ShakerParams;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.factory.FlumpMovieAnimFactory;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.system.DeviceCapabilities;
import com.isartdigital.utils.ui.UIPosition;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.SmartScreen;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UIMovie;
import flump.IFlumpMovie;
import js.Lib;
import js.html.MouseEvent;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject;
import pixi.core.math.Point;
import pixi.core.sprites.Sprite;
import pixi.core.text.Text;
import pixi.core.textures.Texture;
import pixi.filters.color.ColorMatrixFilter;
import pixi.flump.Movie;

/**
 * Classe en charge de gérer les informations du Hud
 * @author Michael Wilkins
 */
class Hud extends SmartScreenRegister
{

	private static inline var SHOP_BTN:String = "btn_Shop";
	private static inline var BUILD_BTN:String = "btn_Build";
	private static inline var OPTIONS_BTN:String = "btn_Options";
	private static inline var CODEX_BTN:String = "btn_Codex";
	private static inline var HC_ADD_BTN:String = "btn_PlusHC";
	private static inline var SC_ADD_BTN:String = "btn_PlusSC";

	public static inline var SC_BAR:String = "HUD_clipSoftCurrencie";
	public static inline var HC_BAR:String = "HUD_clipHardCurrencie";
	public static inline var MATERIAL_BAR:String = "HUD_clipMatiere";

	private static inline var PLAYER_INFO_CONTAINER:String = "HUD_clipPlayerInfos";
	private static inline var PLAYER_LVL_TEXTFIELD:String = "txt_PlayerLevel";
	private static inline var TEXTFIELD_SC:String = "txt_hardCurrencyDisplay";
	private static inline var TEXTFIELD_HC:String = "txt_softCurrencieDisplay";
	private static inline var TEXTFIELD_MAT:String = "txt_matiereDisplay";

	private static inline var XP_Container:String = "HUD_spriteCurrentXP";
	private static inline var XP_BAR:String = "HUD_spriteCurrentXP_fill";
	
	private static inline var ENERGY_BAR:String = "HUD_clipEnergyBar";
	private static inline var TEXTFIELD_ENERGY:String = "txt_energyDisplay";

	private var redFilter:ColorMatrixFilter = new ColorMatrixFilter();
	private var whiteFilter:ColorMatrixFilter = new ColorMatrixFilter();
	private var filterFlag:String;
	public var componentToApplyFilterTo:SmartComponent;
	private var colorAmount:Float = 0;

	private var shopButton:SmartButton;
	private var buildButton:SmartButton;
	private var optionsButton:SmartButton;
	private var codexButton:SmartButton;
	public var hcAddButton:SmartButton;
	public var scAddButton:SmartButton;
	
	public var scBar:SmartComponent;
	public var hcBar:SmartComponent;
	public var materialBar:SmartComponent;
	public var energyBar:SmartComponent;
	
	private var frame:UInt = 0;
	/**
	 * instance unique de la classe Hud
	 */
	private static var instance: Hud;

	private var hudTopLeft:Sprite;
	private var hudBottomLeft:Container;

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Hud
	{
		if (instance == null) instance = new Hud();
		return instance;
	}

	public function new(pID:String = null)
	{
		super(pID);
		modal = false;
	//	update();

		shopButton = cast(getChildByName(SHOP_BTN),SmartButton);
		buildButton = cast(getChildByName(BUILD_BTN),SmartButton);
		optionsButton = cast(getChildByName(OPTIONS_BTN),SmartButton);
		codexButton = cast(getChildByName(CODEX_BTN),SmartButton);
		hcAddButton = cast(getChildByName(HC_ADD_BTN),SmartButton);
		scAddButton = cast(getChildByName(SC_ADD_BTN), SmartButton);
		scBar = cast(getChildByName(SC_BAR), SmartComponent);
		hcBar = cast(getChildByName(HC_BAR), SmartComponent);
		materialBar = cast(getChildByName(MATERIAL_BAR), SmartComponent);
		energyBar = cast(getChildByName(ENERGY_BAR), SmartComponent);
		
		//playerInfoContainer = cast(getChildByName(PLAYER_INFO_CONTAINER), SmartComponent);
		//xpBar = cast(xpContainer.getChildByName(XP_BAR), FlumpMovieAnimFactory);

		shopButton.on(MouseEventType.CLICK, shopAction);
		buildButton.on(MouseEventType.CLICK, buildAction);
		optionsButton.on(MouseEventType.CLICK, optionsAction);
		codexButton.on(MouseEventType.CLICK, codexAction);
		hcAddButton.on(MouseEventType.CLICK, hcAddAction);
		scAddButton.on(MouseEventType.CLICK, scAddAction);

		shopButton.on(TouchEventType.TAP, shopAction);
		buildButton.on(TouchEventType.TAP, buildAction);
		optionsButton.on(TouchEventType.TAP, optionsAction);
		codexButton.on(TouchEventType.TAP, codexAction);
		hcAddButton.on(TouchEventType.TAP, hcAddAction);
		scAddButton.on(TouchEventType.TAP, scAddAction);

		
	}

	public function update():Void
	{

		var lComponent:SmartComponent;
		var lTextField:TextSprite;
		var lAnim:UIMovie;

		
		lTextField = cast(scBar.getChildByName(TEXTFIELD_SC), TextSprite);
		lTextField.text = Std.string(Player.getInstance().softCurrency);

		
		lTextField = cast(hcBar.getChildByName(TEXTFIELD_HC), TextSprite);
		lTextField.text = Std.string(Player.getInstance().hardCurrency);

		
		lTextField = cast(materialBar.getChildByName(TEXTFIELD_MAT), TextSprite);
		lTextField.text = Std.string(Player.getInstance().ressource);
		
		lTextField = cast(energyBar.getChildByName(TEXTFIELD_ENERGY), TextSprite);
		lTextField.text = Std.string(Player.getInstance().currentEnergy) + " / " + Std.string(Player.getInstance().maxEnergy);
		

		

		lComponent = cast(getChildByName(PLAYER_INFO_CONTAINER), SmartComponent);
		lTextField = cast(lComponent.getChildByName(PLAYER_LVL_TEXTFIELD), TextSprite);
		lTextField.text = Std.string(Player.getInstance().level );
		
		lAnim = cast(lComponent.getChildByName(XP_Container), UIMovie);
		//var lxpAnim:Movie =  cast(lAnim.anim, Movie);
		// cast(lAnim, Movie);
		//lxpAnim.stop();
		
		//lxpAnim.gotoAndStop(frame);
		//
		var lFrame:UInt = Math.round((30 * Player.getInstance().calculateLevelAdvance()) / 100);
		lAnim.setBehavior(false, false, lFrame);
		//lxpAnim.play();
		//if (lxpAnim.currentFrame == lFrame) lxpAnim.stop();
		//
		//frame = lFrame;
		FTUEManager.register(energyBar);
	}
	
	
	

	public function doAction():Void
	{


			
	}

	public function maskButtons():Void {
	
		buildButton.visible = false;
		shopButton.visible = false;
		scAddButton.interactive = false;
		hcAddButton.interactive = false;
		codexButton.visible = false;
	}
	
	public function unmaskButtons():Void {
	
		buildButton.visible = true;
		shopButton.visible = true;
		scAddButton.interactive = true;
		hcAddButton.interactive = true;
		codexButton.visible = true;
	}

	private function buildAction()
	{
		SoundManager.getSound("soundPlayerInputBuildButton").play();
		if (BuildingMenu.getInstance().isOpened)
		{
			UIManager.getInstance().closeCurrentPopin();
		}
		else {
			Spawner.getInstance().cancel();
			UIManager.getInstance().closeAllPopins();
			UIManager.getInstance().openPopin(BuildingMenu.getInstance());
		}
	}

	private function shopAction()
	{
		SoundManager.getSound("soundPlayerInputShopButton").play();
		if (Shop.getInstance().isOpened)
		{
			UIManager.getInstance().closeCurrentPopin();
		}

		else
		{
			Spawner.getInstance().cancel();
			UIManager.getInstance().closeAllPopins();
			UIManager.getInstance().openPopin(Shop.getInstance());

		}
	}

	private function optionsAction()
	{
		
		Spawner.getInstance().cancel();
		UIManager.getInstance().closeAllPopins();
		UIManager.getInstance().closeHud();
		UIManager.getInstance().openScreen(Settings.getInstance());
	}

	private function codexAction()
	{
		SoundManager.getSound("soundPlayerInputCodexButton").play();
		Spawner.getInstance().cancel();
		UIManager.getInstance().closeAllPopins();
		UIManager.getInstance().openPopin(Codex.getInstance());
		
	}

	private function hcAddAction()
	{
		SoundManager.getSound("soundPlayerInputShopButton").play();
		Spawner.getInstance().cancel();
		UIManager.getInstance().closeAllPopins();
		UIManager.getInstance().openPopin(Shop.getInstance());
		Shop.getInstance().currentIndex = 4;
		Shop.getInstance().updateItems();
		
	}

	private function scAddAction()
	{
		SoundManager.getSound("soundPlayerInputShopButton").play();
		Spawner.getInstance().cancel();
		UIManager.getInstance().closeAllPopins();
		UIManager.getInstance().openPopin(Shop.getInstance());
		Shop.getInstance().currentIndex = 1;
		Shop.getInstance().updateItems();
	}
	
	public function noHCAnimation() {
		Hud.getInstance().noEnoughAnimation(hcAddButton);
		Hud.getInstance().noEnoughAnimation(hcBar);
	}
	
	public function noSCAnimation() {
		Hud.getInstance().noEnoughAnimation(scAddButton);
		Hud.getInstance().noEnoughAnimation(scBar);
	}
	
	public function noMaterialAnimation() {
		Hud.getInstance().noEnoughAnimation(materialBar);
	}
	
	public function noEnergyAnimation() {
		Hud.getInstance().noEnoughAnimation(energyBar);
	}
	
	private function noEnoughAnimation(pComponent:SmartComponent) {
		var redParams:ColorFilterParams = 
		{
			colorAmount:1,
			colorToApply: "red",
			duration :1
		}

		var shakeParams : ShakerParams = 
		{
			originalPosition: pComponent.position.clone(),
			smoothness:5,
			amplitude:10,
			duration:40,
			xQuantity: 1.5,
			yQuantity: 0.5,
			fadeOut: 0.95,
			randomShake: true,
			sound:"no"
		}
		
		ColorFilterManager.getInstance().applyFilter(pComponent, redParams);
		SmartShaker.getInstance().SetShaker(pComponent, shakeParams);
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void
	{
		shopButton.off(MouseEventType.CLICK, shopAction);
		buildButton.off(MouseEventType.CLICK, buildAction);
		optionsButton.off(MouseEventType.CLICK, optionsAction);
		codexButton.off(MouseEventType.CLICK, codexAction);
		hcAddButton.off(MouseEventType.CLICK, hcAddAction);
		scAddButton.off(MouseEventType.CLICK, scAddAction);

		shopButton.off(TouchEventType.TAP, shopAction);
		buildButton.off(TouchEventType.TAP, buildAction);
		optionsButton.off(TouchEventType.TAP, optionsAction);
		codexButton.off(TouchEventType.TAP, codexAction);
		hcAddButton.off(TouchEventType.TAP, hcAddAction);
		scAddButton.off(TouchEventType.TAP, scAddAction);

		instance = null;
		super.destroy();
	}

}