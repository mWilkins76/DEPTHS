package com.isartdigital.ruby.ui.popin;
import com.greensock.TweenMax;
import com.isartdigital.ruby.game.sprites.elements.aliens.Alien;
import com.isartdigital.ruby.game.sprites.elements.aliens.AlienElement;
import com.isartdigital.ruby.game.world.MapInteractor;
import com.isartdigital.ruby.ui.items.switchItems.XenosPanelSwitchItem;
import com.isartdigital.ruby.ui.items.switchItems.XenosPanelSwitchTab;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;

	
/**
 * ...
 * @author Michael Wilkins
 */
class XenosPanel extends Menu 
{
	
	static inline var CONTEXTUAL:String = "Contextual";
	static inline var BTN_XENO_PAGE:String = "btn_UnitXenoPage";
	static inline var BTN_UPGRADE:String = "btn_UnitUpgrade";
	static inline var BTN_STORE:String = "btn_UnitCryo"; 
	
	public var contextualItem:SmartComponent;
	private var xenoPageBtn:SmartButton;
	private var upgradeBtn:SmartButton;
	private var storeBtn:SmartButton;
	
	private var btnSell:SmartButton;
	
	public var alienSelected:AlienElement;
	
	
	/**
	 * instance unique de la classe XenosPanel
	 */
	private static var instance: XenosPanel;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): XenosPanel {
		if (instance == null) instance = new XenosPanel();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(pID);
		modal = false;
	}
	
	override function init() 
	{
		super.init();
		contextualItem = cast(getChildByName(CONTEXTUAL), SmartComponent);
		contextualItem.visible = false;
		initTab(XenosPanelSwitchTab);
		initItems();
		
		xenoPageBtn = cast(contextualItem.getChildByName(BTN_XENO_PAGE), SmartButton);
		xenoPageBtn.on(MouseEventType.CLICK, onXenoPage);
		xenoPageBtn.on(TouchEventType.TAP, onXenoPage);
		
		upgradeBtn = cast(contextualItem.getChildByName(BTN_UPGRADE), SmartButton);
		upgradeBtn.on(MouseEventType.CLICK, onUpgrade);
		upgradeBtn.on(TouchEventType.TAP, onUpgrade);
		
		storeBtn = cast(contextualItem.getChildByName(BTN_STORE), SmartButton);
		storeBtn.on(MouseEventType.CLICK, onStore);
		storeBtn.on(TouchEventType.TAP, onStore);
		
		btnSell = cast(getChildByName("btn_Sell"), SmartButton);
		btnSell.visible = false;
	}
	
	/**
	 * stock les item du popin dans un tableau de reference
	 */
	override private function initItems() {
		itemContainer = cast(getChildByName(ITEM_CONTAINER), SmartComponent);
		itemContainer.interactive = true;
		
		initOffsetBetweenItems();
		
		updateItems();
	}
	
	/**
	 * Créer les items et les places
	 */
	public function updateItems() {
		destroyAllChildInContainer(itemContainer);
	
		var count:Int = 0;
		for (i in 0...Alien.alienElementList.length) {
			if (Alien.alienElementList[i].type == "AlienProducer" || Alien.alienElementList[i].type == "AlienBuffer") {
			
				var currentItem = new XenosPanelSwitchItem();
				itemContainer.addChild(currentItem);
				
				currentItem.setInfo(Alien.alienElementList[i]);
				currentItem.x = offsetItem.x * count++;
			}
			
		}
		
	}
	
	public function appearContextualMenuItemAt(pX:Float) {
		var lY:Float = contextualItem.y;
		
		contextualItem.x = pX;
		contextualItem.visible = true;
		TweenMax.fromTo(contextualItem, 0.4, { y:lY + 50, alpha:0}, { y:lY, alpha:1} );
	}
	public function onUpgrade():Void
	{
		
	}
	
	public function onMove():Void 
	{
		
		
		if (alienSelected != null) {
			
			MapInteractor.getInstance().alienSelected = alienSelected;
			MapInteractor.getInstance().highLightAlienBuildings();
		}
	}
	
	public function onXenoPage():Void 
	{
		
	}
	
	public function onStore():Void 
	{
		
	}
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		//xenoPageBtn.off(MouseEventType.CLICK, onXenoPage);
		//xenoPageBtn.off(TouchEventType.TAP, onXenoPage);
		//upgradeBtn.off(MouseEventType.CLICK, onUpgrade);
		//upgradeBtn.off(TouchEventType.TAP, onUpgrade);
		//storeBtn.off(MouseEventType.CLICK, onStore);
		//storeBtn.off(TouchEventType.TAP, onStore);
	}

}