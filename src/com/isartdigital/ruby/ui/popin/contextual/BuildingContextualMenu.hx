package com.isartdigital.ruby.ui.popin.contextual;

import com.greensock.easing.Quart;
import com.isartdigital.ruby.game.controller.Controller;
import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.game.sprites.elements.Building;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienIncubator;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienPaddock;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienTrainingCenter;
import com.isartdigital.ruby.game.sprites.elements.drillingbuilding.DrillingBuilding;
import com.isartdigital.ruby.game.sprites.elements.drillingbuilding.DrillingOutPost;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.UrbanAntenna;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.UrbanHeadQuarter;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.UrbanTranslation;
import com.isartdigital.ruby.game.world.Region;
import com.isartdigital.ruby.game.world.World;
import com.isartdigital.ruby.ui.ftue.FTUEManager;
import com.isartdigital.ruby.ui.hud.Hud;
import com.isartdigital.ruby.ui.popin.centreForage.CentreForage;
import com.isartdigital.ruby.game.sprites.elements.drillingbuilding.DrillingCenter;
import com.isartdigital.ruby.game.world.MapInteractor;
import com.isartdigital.ruby.ui.UIManager;
import com.isartdigital.ruby.ui.popin.enclos.Enclos;
import com.isartdigital.ruby.ui.popin.incubator.Incubator;
import com.isartdigital.ruby.ui.popin.translationCenter.TranslationCenter;
import com.isartdigital.ruby.ui.popin.upgradeCenter.UpgradeCenter;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.Camera;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.iso.IsoManager;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.greensock.TimelineMax;
import com.greensock.TweenMax;
import haxe.Timer;
import pixi.core.math.Point;

	
/**
 * ...
 * @author Jordan Dachicourt
 */
class BuildingContextualMenu extends ContextualPopin 
{	
	private static inline var LEFT_CONTAINER:String = "LeftButtonsPanel";
		private static inline var BTN_DESTROY:String = "btn_Destroy";
		private static inline var BTN_MOVE:String = "btn_Move";
		private static inline var BTN_INFO:String = "btn_Info";
		
	private static inline var RIGHT_CONTAINER:String = "RightButtonsPanel";
		private static inline var BTN_UPGRADE:String = "btn_Upgrade";
		private static inline var BTN_HARVEST:String = "btn_Harvest";
		private static inline var BTN_FEATURE:String = "btn_Feature";
		
	private static inline var INFO_PANEL:String = "InfoPanel";
		private static inline var TEXTFIELD_NAME:String = "txt_BuildingName";
		private static inline var TEXTFIELD_DESCRIPTION:String = "txt_descriptionBuilding";
		private static inline var TEXTFIELD_LEVEL:String = "txt_levelBuilding";
		
	private static inline var CONFIRM_UPGRADE:String = "ConfirmUpgrade";
		private static inline var BTN_UPGRADE_YES:String = "btn_YesBuyHC";
		private static inline var BTN_UPGRADE_NO:String = "btn_NoBuyHC";
		private static inline var UPGRADE_COST:String = "UpgradeCost";
			private static inline var UPGRADE_TXT_CONTAINER:String = "BuildingContextualMenu_clipCostContainer";
				private static inline var UPGRADE_TXT_MN_COST:String = "UpgradeBuilding_txt_MNCost";
				private static inline var UPGRADE_TXT_SC_COST:String = "UpgradeBuilding_txt_SCCost";
		
	private var leftButtons:Array<SmartButton>;
	private var rightButtons:Array<SmartButton>;
	private var leftFinalPosition:Array<Point>;
	private var rightFinalPosition:Array<Point>;
	
	private var leftContainer:SmartComponent;
		private var destroyBtn:SmartButton;
		private var moveBtn:SmartButton;
		private var infoBtn:SmartButton;
		
	private var rightContainer:SmartComponent;
		private var harvestBtn:SmartButton;
		private var upgradeBtn:SmartButton;
		private var featureBtn:SmartButton;
		
	private var confirmUpgradeContainer:SmartComponent;
		private var confirmUpgradeCostContainer:SmartComponent;
			private var confirmUpgradeCostTextContainer:SmartComponent;
				private var mnCost:TextSprite;
				private var scCost:TextSprite;
		private var yesUpgradeBtn:SmartButton;
		private var noUpgradeBtn:SmartButton;
	
	private var infoContainer:SmartComponent;
		private var description:TextSprite;
		private var buildingName:TextSprite;
		private var levelBuilding:TextSprite;
	
		
		private var currentBuilding:Building;
	
	
	
	
	
	
	
	
	
	
	/**
	 * instance unique de la classe BuildingContextualMenu
	 */
	private static var instance: BuildingContextualMenu;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): BuildingContextualMenu {
		if (instance == null) instance = new BuildingContextualMenu();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(pID);
		
	}
	
	public function init():Void {
		
		modal = false;
		visible = false;
		initLeft();
		initRight();
		initInfoPanel();	
		initConfirmUpgrade();		
		visible = true;
	}
	
	override function initPositionCenterTarget() 
	{
		super.initPositionCenterTarget();
		currentBuilding = cast(target, Building);
		currentBuilding.removeHoverFilter();
	}
	
	
	private function initLeft() {
		leftButtons = new Array<SmartButton>();
		leftFinalPosition = new Array<Point>();
		
		leftContainer = cast(getChildByName(LEFT_CONTAINER), SmartComponent);
			moveBtn = cast(leftContainer.getChildByName(BTN_MOVE), SmartButton);
			moveBtn.on(MouseEventType.CLICK, moveBuilding);
			moveBtn.on(TouchEventType.TAP, moveBuilding);
			if (Std.is(target, AlienPaddock)) moveBtn.visible = false;
			
			destroyBtn = cast(leftContainer.getChildByName(BTN_DESTROY), SmartButton);
			destroyBtn.on(MouseEventType.CLICK, destroyBuilding);
			destroyBtn.on(TouchEventType.TAP, destroyBuilding);
			if (Std.is(target, UrbanHeadQuarter)) destroyBtn.visible = false;
			
			infoBtn = cast(leftContainer.getChildByName(BTN_INFO), SmartButton);
			infoBtn.on(MouseEventType.CLICK, showInfo);
			infoBtn.on(TouchEventType.TAP, showInfo);
			
		for (child in leftContainer.children) {	
			leftButtons.push(cast(child, SmartButton));
			leftFinalPosition.push(child.position.clone());
			child.x = 0;
			child.y = 0;
		}
	}
	
	private function initRight() {
		rightButtons = new Array<SmartButton>();
		rightFinalPosition = new Array<Point>();
		rightContainer = cast(getChildByName(RIGHT_CONTAINER), SmartComponent);
			upgradeBtn = cast(rightContainer.getChildByName(BTN_UPGRADE), SmartButton);
			upgradeBtn.on(MouseEventType.CLICK, clickUpgrade);
			upgradeBtn.on(TouchEventType.TAP, clickUpgrade);
			
			
			if (target.maxLevel == target.level || Std.is(target, UrbanAntenna) || Std.is(target, AlienTrainingCenter))
			{
				upgradeBtn.visible = false;
			}
			else {
				if (Std.is(target, UrbanHeadQuarter) || target.level < Building.HQinstance.level) upgradeBtn.visible = true;
				else upgradeBtn.visible = false;
			}
				
			featureBtn = cast(rightContainer.getChildByName(BTN_FEATURE), SmartButton);
			featureBtn.on(MouseEventType.CLICK, openFeature);
			featureBtn.on(TouchEventType.TAP, openFeature);
			if (!Std.is(target, DrillingCenter) && !Std.is(target, DrillingOutPost) && !Std.is(target, AlienIncubator) &&  !Std.is(target, UrbanTranslation) && !Std.is(target, AlienTrainingCenter)&& !Std.is(target, AlienPaddock))
				featureBtn.visible = false;
			
			harvestBtn = cast(rightContainer.getChildByName(BTN_HARVEST), SmartButton);
			harvestBtn.on(MouseEventType.CLICK, harvest);
			harvestBtn.on(TouchEventType.TAP, harvest);
			
			if (!Std.is(target, AlienPaddock))
				harvestBtn.visible = false;
				
		for (child in rightContainer.children) {	
			rightButtons.push(cast(child, SmartButton));
			rightFinalPosition.push(child.position.clone());
			child.x = 0;
			child.y = 0;
		}
		FTUEManager.register(featureBtn);
		Timer.delay(sendEvent, 500);
	}
	
	private function sendEvent():Void
	{
		
		trace("");// !!!! NE PAS VIRER !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		SmartPopinRegister.event.emit("onInit");
	}
	
	private function initInfoPanel() {
		infoContainer = cast(getChildByName(INFO_PANEL), SmartComponent);
		infoContainer.visible = false;
			buildingName = cast(getChildByName(TEXTFIELD_NAME), TextSprite);
			
			description = cast(infoContainer.getChildByName(TEXTFIELD_DESCRIPTION), TextSprite);
			description.text = "";
		
			levelBuilding = cast(infoContainer.getChildByName(TEXTFIELD_LEVEL), TextSprite);
			levelBuilding.text = "";
	}
	
	private function initConfirmUpgrade() {
		confirmUpgradeContainer = cast(getChildByName(CONFIRM_UPGRADE), SmartComponent);
		confirmUpgradeContainer.visible = false;
			yesUpgradeBtn = cast(confirmUpgradeContainer.getChildByName(BTN_UPGRADE_YES), SmartButton);
			yesUpgradeBtn.visible = false;
			yesUpgradeBtn.on(MouseEventType.CLICK, upgradeBuilding);
			yesUpgradeBtn.on(TouchEventType.TAP, upgradeBuilding);
			noUpgradeBtn = cast(confirmUpgradeContainer.getChildByName(BTN_UPGRADE_NO), SmartButton);
			noUpgradeBtn.visible = false;
			noUpgradeBtn.on(MouseEventType.CLICK, clickUpgrade);
			noUpgradeBtn.on(TouchEventType.TAP, clickUpgrade);
			confirmUpgradeCostContainer = cast(confirmUpgradeContainer.getChildByName(UPGRADE_COST), SmartComponent);
				confirmUpgradeCostTextContainer = cast(confirmUpgradeCostContainer.getChildByName(UPGRADE_TXT_CONTAINER), SmartComponent);
					scCost = cast(confirmUpgradeCostTextContainer.getChildByName(UPGRADE_TXT_SC_COST), TextSprite);
					mnCost = cast(confirmUpgradeCostTextContainer.getChildByName(UPGRADE_TXT_MN_COST), TextSprite);
	}
	
	public function update():Void 
	{
		buildingName.text = Std.string(currentBuilding.buildingName);
		description.text = currentBuilding.description;
		animationsContainers();
	}
	
	private function playSFX():Void{
		SoundManager.getSound("soundPlayerSwitchMode").play();
	}
	public function animationsButtons() {
		
		playSFX();
		
		for (i in 0 ... leftFinalPosition.length) {
			
			var tween : TweenMax = new TweenMax(
				leftButtons[i],
				0.2, 
					{ x : leftFinalPosition[i].x, 
					  y: leftFinalPosition[i].y,
					  ease:Quart.easeIn,
					  onComplete:playSFX
					}
			);
		}
		
		for (i in 0 ... rightFinalPosition.length) {
			
			var tween : TweenMax = new TweenMax(
				rightButtons[i],
				0.2, 
					{ x : rightFinalPosition[i].x, 
					  y: rightFinalPosition[i].y,
					  ease:Quart.easeIn 
					  
					}
			);
		}
	}
	
	public function animationsContainers() {
		var lLeftPoint:Point = leftContainer.position.clone();
		leftContainer.position = new Point(0, 0);
		var lRightPoint:Point = rightContainer.position.clone();
		rightContainer.position = new Point(0, 0);
		
		var tween : TweenMax = new TweenMax(
			leftContainer,
			0.2, 
				{ x : lLeftPoint.x, 
				  y: lLeftPoint.y,
				  onComplete:animationsButtons,
				  ease:Quart.easeIn 
				  
				}
		);
		
		var tween : TweenMax = new TweenMax(
			rightContainer,
			0.2, 
				{ x : lRightPoint.x, 
				  y: lRightPoint.y,
				  onComplete:animationsButtons,
				  ease:Quart.easeIn 
				  
				}
		);
		
	}
	
	public function animationsInfoPanel() {
		
		infoContainer.scale.x = 0;
		infoContainer.scale.y = 0;
		
		var tween : TweenMax = new TweenMax(
			infoContainer.scale,
			0.3, 
			{ 
			  x:1,
			  y:1,
			  ease:Quart.easeIn 
			}
		);	
	}
	
	public function animationConfirmUpgrade() {
		confirmUpgradeContainer.visible = true;
		TweenMax.fromTo(confirmUpgradeContainer.scale, 0.2, { x :0, y:0}, { x:1, y:1} );
	}
	
	private function animationConfirmBtns() {
		yesUpgradeBtn.visible = true;
		noUpgradeBtn.visible = true;
		
		TweenMax.fromTo(yesUpgradeBtn, 0.1, { x : confirmUpgradeCostContainer.x, y : confirmUpgradeCostContainer.y, alpha : 0 }, { x:yesUpgradeBtn.x, y:yesUpgradeBtn.y, alpha : 1, delay:0.2 } );
		TweenMax.fromTo(noUpgradeBtn, 0.1, { x : confirmUpgradeCostContainer.x, y : confirmUpgradeCostContainer.y, alpha : 0}, { x:noUpgradeBtn.x, y:noUpgradeBtn.y, alpha : 1, delay:0.2} );
	}
	
	private function upgradeBuilding():Void {
		if (currentBuilding.canAffordUpgrade()) currentBuilding.startUpgrading();
	}
	
	private function clickUpgrade() {
		if (!confirmUpgradeContainer.visible) {
			animationConfirmUpgrade();
			animationConfirmBtns();
			updateConfirmInfo();
			SoundManager.getSound("soundPlayerSwitchMode").play();
		}
		else confirmUpgradeContainer.visible = false;
	}
	
	private function updateConfirmInfo() {
		scCost.text = currentBuilding.costUpgradeSC+"";
		mnCost.text = currentBuilding.costUpgradeMN+"";
	}
	
	private function destroyBuilding():Void {
		SoundManager.getSound("soundPlayerSwitchMode").play();
		UIManager.getInstance().openPopin(Destruction.getInstance());
	}
	
	private function openFeature():Void 
	{
		SoundManager.getSound("soundPlayerSwitchMode").play();
		UIManager.getInstance().closeAllPopins();
		MapInteractor.getInstance().modalPopinOpened = true;
        if(Std.is(target, DrillingCenter) || Std.is(target, DrillingOutPost))
            UIManager.getInstance().openPopin(CentreForage.getInstance());
        else if (Std.is(target, UrbanTranslation))
        {
            UIManager.getInstance().openPopin(TranslationCenter.getInstance());    
        }
        else if (Std.is(target, AlienIncubator))
        {
            var lCurBuilding:AlienIncubator = cast(target, AlienIncubator);
            UIManager.getInstance().openPopin(Incubator.getInstance());
			Incubator.getInstance().initializationCurrentBuildingIncubator(lCurBuilding);
        }
		
		else if (Std.is(target, AlienTrainingCenter))
		{
			var lCurBuilding:AlienTrainingCenter = cast(target, AlienTrainingCenter);
			UpgradeCenter.getInstance().initializationCurrentBuildingTrainingCenter(lCurBuilding);
			UIManager.getInstance().openPopin(UpgradeCenter.getInstance());
			
		}
		else if (Std.is(target, AlienPaddock))
        {
            var lCurBuilding:AlienPaddock = cast(target, AlienPaddock);
            UIManager.getInstance().openPopin(Enclos.getInstance());
            Enclos.getInstance().initPopin(lCurBuilding);
        }
    }
	
	private function harvest():Void {
		SoundManager.getSound("soundPlayerSwitchMode").play();
		var lApaddock:AlienPaddock = cast(target, AlienPaddock);
		lApaddock.setModeCollectable();
		lApaddock.onCollect();
		
	}
	
	public function isDestroyConfirmed():Void 
	{
		var SoftCurrency:Int = Std.int(Reflect.field(currentBuilding.buildingType, "SellingCost"));
		Player.getInstance().changePlayerValue(SoftCurrency, Player.TYPE_SOFTCURRENCY);
		target.setModeDestroy();
	}
	
	private function moveBuilding():Void 
	{

		currentBuilding.setModeMove();
		//MapInteractor.getInstance().closeInfoPanel();
	}
	
	private function showInfo():Void {
		SoundManager.getSound("soundPlayerSwitchMode").play();
		if (!infoContainer.visible) {
			infoContainer.visible = true;
			
			description.text = currentBuilding.description;
			levelBuilding.text = target.level + " / " + target.maxLevel;
			animationsInfoPanel();
			//if (Std.is(currentBuilding, AlienPaddock))//show produce; 
			
		}else
			infoContainer.visible = false;
	}
	
	override public function close():Void 
	{
		removeAllListeners(MouseEventType.CLICK);
		removeAllListeners(TouchEventType.TAP);
		currentBuilding.contextualOpened = false;
		super.close();
	}
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		removeAllListeners(MouseEventType.CLICK);
		removeAllListeners(TouchEventType.TAP);
		instance = null;
	}

}