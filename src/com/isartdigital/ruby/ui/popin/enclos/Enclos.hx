package com.isartdigital.ruby.ui.popin.enclos;

import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienPaddock;
import com.isartdigital.ruby.game.sprites.elements.aliens.AlienElement;
import com.isartdigital.ruby.game.world.MapInteractor;
import com.isartdigital.ruby.ui.popin.SmartPopinRegister;
import com.isartdigital.ruby.ui.popin.codex.XenoCodexTypedef;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import pixi.core.math.Point;

	
/**
 * ...
 * @author Michael Wilkins
 */
class Enclos extends MenuClosable 
{
	private static inline var NAME = "txt_XenoName #";
	private static inline var CONTEXTUAL_CNTNER = "clipContextualButtonsContainer";
	private static inline var LEVEL_CNTNER = "clipLevelContainer";
	private static inline var XENO_CNTNER = "clipXenoContainer";
	
	private static inline var LEVEL_PICTO = "Enclos_clipUnitLevel #";
	private static inline var LEVEL_TEXT = "Enclos_txt_Level";
	
	private static inline var XENO_SWITCH = "Enclos_clipUnitSwitch #";
	
	private static inline var BTN_MOVE = "Enclos_btn_UnitMove";
	private static inline var BTN_INFO = "Enclos_btn_UnitXenoPage";
	private static inline var BTN_FREEZE = "Enclos_btn_UnitCryo";
	private static inline var BTN_UPGRADE = "Enclos_btn_UnitUpgrade";
	
	public var alienSelected:AlienElement;
	
	private var nameList:Array<TextSprite>;
	private var lvlList:Array<TextSprite>;
	private var lvlPictoList:Array<SmartComponent>;
	private var switchList:Array<EnclosSwitchItem>;
	private var contextualMenu:SmartComponent;
	private var levelContainer:SmartComponent;
	private var xenoContainer:SmartComponent;
	
	private var currentPaddock:AlienPaddock;
	
	private var moveBtn:SmartButton;
	private var infoBtn:SmartButton;
	private var freezeeBtn:SmartButton;
	private var upgradeBtn:SmartButton;
	/**
	 * instance unique de la classe Enclos
	 */
	private static var instance: Enclos;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Enclos {
		if (instance == null) instance = new Enclos();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(pID);
		modal = true;
		init();
	}
	
	override function init():Void 
	{
		super.init();
		
		nameList = new Array<TextSprite>();
		lvlList = new Array<TextSprite>();
		switchList = new Array<EnclosSwitchItem>();
		lvlPictoList = new Array<SmartComponent>();
		contextualMenu = cast(getChildByName(CONTEXTUAL_CNTNER), SmartComponent);
		levelContainer = cast(getChildByName(LEVEL_CNTNER), SmartComponent);
		xenoContainer = cast(getChildByName(XENO_CNTNER), SmartComponent);
		
		for (i in 0...6) {
		
			var lName:TextSprite = cast(getChildByName(NAME+i), TextSprite);
			nameList.push(lName);
			
			var lLevelPicto:SmartComponent = cast(levelContainer.getChildByName(LEVEL_PICTO + i), SmartComponent);
			lvlPictoList.push(lLevelPicto);
			var lLevelText:TextSprite = cast(lLevelPicto.getChildByName(LEVEL_TEXT), TextSprite);
			lvlList.push(lLevelText);
			
			var lSwitch:EnclosSwitchItem = cast(xenoContainer.getChildByName(XENO_SWITCH + i), EnclosSwitchItem);
			lSwitch.setNormal();
			switchList.push(lSwitch);
		}
		
		moveBtn = cast(contextualMenu.getChildByName(BTN_MOVE), SmartButton);
		infoBtn = cast(contextualMenu.getChildByName(BTN_INFO), SmartButton);
		freezeeBtn = cast(contextualMenu.getChildByName(BTN_FREEZE), SmartButton);
		upgradeBtn = cast(contextualMenu.getChildByName(BTN_UPGRADE), SmartButton);
		
		moveBtn.on(MouseEventType.CLICK, moveAlien);
		moveBtn.on(TouchEventType.TAP, moveAlien);
		infoBtn.on(MouseEventType.CLICK, infoAlien);
		infoBtn.on(TouchEventType.TAP, infoAlien);
		freezeeBtn.on(MouseEventType.CLICK, freezeAlien);
		freezeeBtn.on(TouchEventType.TAP, freezeAlien);
		upgradeBtn.on(MouseEventType.CLICK, upgradeAlien);
		upgradeBtn.on(TouchEventType.TAP, upgradeAlien);
		
		contextualMenu.visible = false;
		
		
		
	}
	
	
	public function initPopin(pPaddock:AlienPaddock):Void {
	
		currentPaddock = pPaddock;
		
		for (i in 0...switchList.length) 
		{
			nameList[i].text = "Emplacement vide";
			
			if (i > currentPaddock.room - 1) {
					
				switchList[i].visible = false;
				nameList[i].visible = false;
				lvlList[i].visible = false;
				lvlPictoList[i].visible = false;
			}
		}
		
		for (i in 0...currentPaddock.totalAliens.length) {
		
			var lAlien:AlienElement = currentPaddock.totalAliens[i];
			switchList[i].setAlien(lAlien);
			//nameList[i].text = lAlien.nomPropre;
			nameList[i].text = lAlien.name;
			lvlList[i].text = Std.string(lAlien.level);
		}
	}
	
	public function positionContextualMenu(pPosition:Point):Void {
	
		contextualMenu.visible = true;
		contextualMenu.position = pPosition;
	}
	
	
	private function moveAlien():Void {
	
		if (alienSelected == null) return;
		
		currentPaddock.removeAlien(alienSelected);
		MapInteractor.getInstance().highLightAlienBuildings();
	}
	
	private function infoAlien():Void {
	
		if (alienSelected == null) return;
		UIManager.getInstance().openPopin(XenoPage.getInstance());
		//var lxenoType:XenoCodexTypedef = new XenoCodexTypedef();
		//lxenoType.name = "trololo";
		//XenoPage.getInstance().setAlienInfoToDisplay(lxenoType);
	}
	
	private function freezeAlien():Void {
	
		if (alienSelected == null) return;
	}
	
	private function upgradeAlien():Void {
	
		if (alienSelected == null) return;
	}
	
	
	override public function close():Void 
	{
		super.close();
		MapInteractor.getInstance().modalPopinOpened = false;
	}
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}