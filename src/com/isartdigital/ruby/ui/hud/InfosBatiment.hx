package com.isartdigital.ruby.ui.hud;

import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.game.sprites.elements.Building;
import com.isartdigital.ruby.ui.popin.centreForage.CentreForage;
import com.isartdigital.ruby.game.sprites.elements.drillingbuilding.DrillingCenter;
import com.isartdigital.ruby.game.world.MapInteractor;
import com.isartdigital.ruby.ui.popin.Destruction;
import com.isartdigital.ruby.ui.popin.Menu;
import com.isartdigital.ruby.ui.popin.incubator.Incubator;
import com.isartdigital.ruby.game.specialFeature.managers.SpecialFeatureScreen;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.TextSprite;

	
/**
 * ...
 * @author Michael Wilkins
 */
class InfosBatiment extends Menu 
{
	
	
	private static inline var UPGRADE_BTN:String = "btn_Upgrade";
	private static inline var DESTROY_BTN:String = "btn_Destroy";
	private static inline var MOVE_BTN:String = "btn_Moove";
	private static inline var DESCRIPTION_TEXTFIELD:String = "txt_descriptionBuilding";
	private static inline var BUILDINGNAME_TEXTFIELD:String = "InfosBatiment_ItemName";
	
	private var buildingInfoContainer:SmartComponent;
	
	private var upgradeBtn:SmartButton;
	private var destroyBtn:SmartButton;
	private var moveBtn:SmartButton;
	private var description:TextSprite;
	private var title:TextSprite;
	
	public var currentBuilding:Building;
	
	
	/**
	 * instance unique de la classe InfosBatiment
	 */
	private static var instance: InfosBatiment;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): InfosBatiment {
		if (instance == null) instance = new InfosBatiment();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(pID);
		init();	
	}
	
	
	override private function init():Void {
		
		super.init();
		
		
		
		upgradeBtn = cast(getChildByName(UPGRADE_BTN), SmartButton);
		upgradeBtn.on(MouseEventType.CLICK, upgradeBuilding);
		upgradeBtn.on(TouchEventType.TAP, upgradeBuilding);
		
		destroyBtn = cast(getChildByName(DESTROY_BTN), SmartButton);
		destroyBtn.on(MouseEventType.CLICK, destroyBuilding);
		destroyBtn.on(TouchEventType.TAP, destroyBuilding);
		
		moveBtn = cast(getChildByName(MOVE_BTN), SmartButton);
		moveBtn.on(MouseEventType.CLICK, moveBuilding);
		moveBtn.on(TouchEventType.TAP, moveBuilding);
		
		description = cast(getChildByName(DESCRIPTION_TEXTFIELD), TextSprite);
		title = cast(getChildByName(BUILDINGNAME_TEXTFIELD), TextSprite);
		
	}
	
	
	override function update():Void 
	{
		title.text = Std.string(currentBuilding.buildingName);
		description.text = currentBuilding.description;
	}
	
	
	private function upgradeBuilding():Void {
		
		//currentBuilding.upgrade();
		if (currentBuilding.buildingName == "Incubator")
		{
			UIManager.getInstance().closeCurrentPopin();
			UIManager.getInstance().openPopin(Incubator.getInstance());
		}
	}
	
	private function destroyBuilding():Void {
		
		UIManager.getInstance().openPopin(Destruction.getInstance());
	}
	
	public function isDestroyConfirmed():Void 
	{
		var SoftCurrency:Int = Std.int(Reflect.field(currentBuilding.buildingType, "SellingCost"));
		Player.getInstance().changePlayerValue(SoftCurrency, Player.TYPE_SOFTCURRENCY);
		currentBuilding.setModeDestroy();
	}
	
	private function moveBuilding():Void {
		
		currentBuilding.setModeMove();
		MapInteractor.getInstance().closeInfoPanel();
	}
	
	override function onClose():Void 
	{
		MapInteractor.getInstance().closeInfoPanel();
		
		if (Std.is(currentBuilding, DrillingCenter))
		{	
			UIManager.getInstance().closeScreens();
			UIManager.getInstance().openHud();
			
		}
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		
		
		close_btn.off(MouseEventType.CLICK, onClose);
		close_btn.off(TouchEventType.TAP, onClose);
		upgradeBtn.off(MouseEventType.CLICK, upgradeBuilding);
		upgradeBtn.off(TouchEventType.TAP, upgradeBuilding);
		destroyBtn.off(MouseEventType.CLICK, destroyBuilding);
		destroyBtn.off(TouchEventType.TAP, destroyBuilding);
		moveBtn.off(MouseEventType.CLICK, moveBuilding);
		moveBtn.off(TouchEventType.TAP, moveBuilding);
		
	}

}