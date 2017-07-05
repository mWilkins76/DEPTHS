package com.isartdigital.ruby.ui.popin;
import com.isartdigital.ruby.game.sprites.elements.aliens.AlienElement;
import com.isartdigital.ruby.ui.popin.building.datas.Missions.Reward;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.system.Localization;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import js.Lib;

	
/**
 * ...
 * @author Adrien Bourdon
 */
class RewardNotifications extends SmartPopinRegister 
{
	
	private static inline var TITLE:String = "txt_NotificationTitle";
	private static inline var CLOSE_BTN:String = "btn_Close";
	private static inline var CONTINUE_BTN:String = "btn_Continue";
	private static inline var SHARE_CLIP:String = "RewardNotifications_clipShare";
	private static inline var LOGO_CONTAINER:String = "RewardNotification_spriteContainerPrincipal";
	private static inline var REWARD_CONTAINER:String = "RewardNotification_spriteContainerRewards";
	private static inline var LOGO:String = "RewardNotifications_spritePrincipal";
    private static inline var REWARD:String = "RewardNotifications_clipRewardUnit";
	
	private var title:TextSprite;
	private var btnContinue:SmartButton;
	private var btnClose:SmartButton;
	private var shareContainer:SmartComponent;
	private var logoContainer:SmartComponent;
	private var rewardContainer:SmartComponent;
	
	private var alienSprite1:UISprite;
	private var alienSprite2:UISprite;
	private var alienSprite3:UISprite;
	
	private var alienSpriteList:Array<UISprite>;
	

	
	private var rewardList: Array<SmartComponent>;
	private var rewardTextList: Array<Int>;
	private var rewardTypeList: Array<String>;
	
	
	
	
	/**
	 * instance unique de la classe RewardNotification
	 */
	private static var instance: RewardNotifications;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): RewardNotifications {
		if (instance == null) instance = new RewardNotifications();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(pID);
		alienSpriteList = [];
		rewardList = [];
		rewardTypeList = [];
		rewardTextList = [];
		title = cast(getChildByName(TITLE), TextSprite);
		btnContinue = cast(getChildByName(CONTINUE_BTN), SmartButton);
		btnClose = cast(getChildByName(CLOSE_BTN), SmartButton);
		shareContainer = cast(getChildByName(SHARE_CLIP), SmartComponent);
		logoContainer = cast(getChildByName(LOGO_CONTAINER), SmartComponent);
			alienSprite1 =  cast(logoContainer.getChildByName("RewardNotifications_spritePrincipal #0"), UISprite);
			alienSpriteList.push(alienSprite1);
			alienSprite2 =  cast(logoContainer.getChildByName("RewardNotifications_spritePrincipal #2"), UISprite);
			alienSpriteList.push(alienSprite2);
			alienSprite3 =  cast(logoContainer.getChildByName("RewardNotifications_spritePrincipal #1"), UISprite);
			alienSpriteList.push(alienSprite3);
		rewardContainer	= cast(getChildByName(REWARD_CONTAINER), SmartComponent);
		for (i in 0...6){
			
			var lComponent:SmartComponent = cast(rewardContainer.getChildByName("RewardNotifications_clipRewardUnit #" + i), SmartComponent);
			rewardList.push(lComponent);
		}
			
	}
	
	public function initLevelUp(pLvl:Int):Void
	{
		reset();
		shareContainer.visible = true;
		btnClose.visible = false;
		btnContinue.on(MouseEventType.CLICK, onClick);
		btnContinue.on(MouseEventType.CLICK, onClick);
		alienSprite1.visible = false;
		alienSprite3.visible = false;
		title.text = Localization.getLabel("LABEL_LEVEL_UP") +" " + pLvl;
		var lReward:Reward;
		lReward = {
		
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
		
		if (pLvl == 2) {
		
			lReward = {
		
			hc:0,
			sc:100,
			gene1:10,
			gene2:0,
			gene3:0,
			gene4:0,
			gene5:0,
			schema:0,
			darkMatter:100
			
			}
		}
		
		if (pLvl == 3) {
		
			lReward = {
		
			hc:0,
			sc:150,
			gene1:15,
			gene2:5,
			gene3:0,
			gene4:0,
			gene5:0,
			schema:0,
			darkMatter:100
			
			}
		}
	
		initRewardContainer(lReward);
		initLogoContainer();
		SmartPopinRegister.event.emit("onInit");
	}
	
	public function initMissionEnd(pMissionReward:Reward, pXenoList:Array<AlienElement>) {
	
		Lib.debug();
		//trace(pXenoList[0].name);
		reset();
		for (sprite in alienSpriteList) sprite.visible = false;
		shareContainer.visible = true;
		btnClose.visible = false;
		btnContinue.on(MouseEventType.CLICK, onClick);
		btnContinue.on(MouseEventType.CLICK, onClick);
		
		for (i in 0...pXenoList.length-1) {
		
			//trace(pXenoList[i].name);
			var lXeno = pXenoList[i];
			alienSpriteList[i].visible = true;
			setAssetAlien(alienSpriteList[i], lXeno);
			
		}

		title.text = "Bravo !";
		
		initRewardContainer(pMissionReward);
		initLogoContainer();
		SmartPopinRegister.event.emit("onInit");
		
		
	}
	
	public function reset():Void {
	
		for (component in rewardList) {
		
			component.visible = true;
			cast(component.getChildByName("RewardNotifications_spriteReward"), UISprite).visible = true;
		}
	}
	
	public function setAssetReward():Void {
	
		for (i in 0...rewardTextList.length) {
		
			var lComponent:SmartComponent = rewardList[i];
			var lText:TextSprite = cast(lComponent.getChildByName("txt_itemQuantity"), TextSprite);
			var lWrongAsset:UISprite =  cast(lComponent.getChildByName("RewardNotifications_spriteReward"), UISprite);
			
			lText.text = "x"+Std.string(rewardTextList[i]);
			var lNewAsset:UISprite = new UISprite("RewardNotification_" +rewardTypeList[i]);
			lNewAsset.name = "mainAsset";
			lNewAsset.position = lWrongAsset.position.clone();
			lComponent.addChild(lNewAsset);
			lWrongAsset.visible = false;
			
		}
		
		for (i in 0...rewardList.length) {
		
			if (i >= rewardTextList.length) rewardList[i].visible = false;
		}
		
		while (rewardTextList.length > 0) rewardTextList.pop();
		while (rewardTypeList.length > 0) rewardTypeList.pop();
		
		
	}
	
	public function setAssetAlien(pAsset:UISprite, pAlien:AlienElement) {
		
		var lAsset:UISprite;
		
		
		lAsset = new UISprite("Enclos_" + pAlien.name + "_lvl1");
		
		lAsset.name = "mainAsset"+pAlien.name;
		lAsset.position = pAsset.position.clone();
		lAsset.position.y -= 130;
		//if (currentState.getChildByName(lAsset.name) != null)
			//currentState.removeChild(currentState.getChildByName(lAsset.name));
			
		addChild(lAsset);
		pAsset.visible = false;
	}
	

	
	
	
	private function initRewardContainer(pMissionReward:Reward):Void
	{
			if (pMissionReward.sc != 0) {
			rewardTextList.push(pMissionReward.sc);
			rewardTypeList.push("SoftCurrency");
		}
		
		if (pMissionReward.hc != 0) {
			rewardTextList.push(pMissionReward.hc);
			rewardTypeList.push("HardCurrency");
		}
		
		if (pMissionReward.darkMatter != 0) {
			rewardTextList.push(pMissionReward.darkMatter);
			rewardTypeList.push("MN");
		}
		
		if (pMissionReward.schema != 0) {
			rewardTextList.push(pMissionReward.schema);
			rewardTypeList.push("Parchemin");
		}
		
		if (pMissionReward.gene1 != 0) {
			rewardTextList.push(pMissionReward.gene1);
			rewardTypeList.push("Rho");
		}
		
		if (pMissionReward.gene2 != 0) {
			rewardTextList.push(pMissionReward.gene2);
			rewardTypeList.push("Upsilon");
		}
		
		if (pMissionReward.gene3 != 0) {
			rewardTextList.push(pMissionReward.gene3);
			rewardTypeList.push("Beta");
		}
		
		if (pMissionReward.gene4 != 0) {
			rewardTextList.push(pMissionReward.gene4);
			rewardTypeList.push("Iota");
		}
		
		if (pMissionReward.gene5 != 0) {
			rewardTextList.push(pMissionReward.gene5);
			rewardTypeList.push("Sigma");
		}
		
		setAssetReward();
	}
	
	private function initLogoContainer():Void
	{
		
	}
	
	public function onClick():Void
	{
		//event.emit("onOpen");
		UIManager.getInstance().closePopin(this);
		SoundManager.getSound("soundAtmosphere").play();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		btnContinue.off(MouseEventType.CLICK, onClick);
		btnContinue.off(MouseEventType.CLICK, onClick);
	}

}