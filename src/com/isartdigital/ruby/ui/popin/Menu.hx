package com.isartdigital.ruby.ui.popin;

import com.greensock.TweenMax;
import com.greensock.easing.Quart;
import com.isartdigital.ruby.ui.ftue.FTUEManager;
import com.isartdigital.ruby.ui.items.switchItems.SwitchGroupItem;
import com.isartdigital.ruby.ui.items.switchItems.SwitchItem;
import com.isartdigital.ruby.ui.popin.SmartPopinRegister;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;
import pixi.core.display.DisplayObject;
import pixi.core.math.Point;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author Jordan Dachicourt
 */
class Menu extends MenuClosable
{
	public var TAB_CONTAINER(default, never):String = "TabContainer";
	public var ITEM_CONTAINER(default, never):String = "ItemContainer";
	public var BTN_TAB(default, never):String = "tab";
	public var ITEM(default, never):String = "item";

	

	
	/** 
	 * les onglet 
	 * **/
	private var tabButtons:Array<SwitchGroupItem>;
	private var tabContainer:SmartComponent;
	private var offsetTab:Point;
	private var offsetItem:Point;
	private var firstItemPosition:Point;
	/**
	 * Index correspondant à l'onglet actif
	 */
	public var currentIndex:Int = 0;
	
	public var itemContainer(default, null):SmartComponent;
	
	public function new(pID:String=null) 
	{
		super(pID);
		modal = false;
	}
	
	override public function open():Void 
	{
		super.open();
		
		init();
		
		scale.x = 0;
		scale.y = 0;
		var tween : TweenMax = new TweenMax(
			scale,
			0.3, 
				{ x : 1, 
				  y: 1,
				  ease:Quart.easeIn 
				  
				}
		);
	}
	
	
	public function update():Void {
		
	}
	
	private function initOffsetBetweenItems() {
		
		firstItemPosition = itemContainer.getChildByName(ITEM + " #0").position;
		var lNextItem:DisplayObject = itemContainer.getChildByName(ITEM + " #1");
		if (lNextItem != null) {
			offsetItem = new Point( lNextItem.x - firstItemPosition.x, lNextItem.y - firstItemPosition.y);
		}
		
	}
	/**
	 * initialise les onglet
	 */
	private function initTab(pTabClass:Class<Dynamic>) {
		tabButtons = new Array<SwitchGroupItem>();
		tabContainer = cast(getChildByName(TAB_CONTAINER), SmartComponent);
		FTUEManager.register(tabContainer);
	
		offsetTab = new Point(tabContainer.children[0].x - tabContainer.children[1].x, tabContainer.children[0].y - tabContainer.children[1].y);
		
		if (tabContainer == null || tabContainer.children.length == 0) { trace("tabContainer doesn't exist or doesn't have any children"); return; }
		
		var lTabLength:Int = tabContainer.children.length;
		var lTabFirstItemPosition:Point =  tabContainer.getChildByName(ITEM+" #0").position;
		
		destroyAllChildInContainer(tabContainer);
		
		for (i in 0 ... lTabLength) {
			tabButtons.push(Type.createInstance( pTabClass, [] ));
			tabButtons[i].x = lTabFirstItemPosition.x + i * offsetTab.x;
			tabButtons[i].y = lTabFirstItemPosition.y + i * offsetTab.y;
			tabButtons[i].name = "tabButton" + i;
			tabContainer.addChild(tabButtons[i]);
			tabButtons[i].id = i;

			tabButtons[i].init();
			FTUEManager.register(tabButtons[i]);
			
			if (i == currentIndex) {
				
				tabButtons[i].setActive();
			}
		}
	}
	
	/**
	 * stock les item du popin dans un tableau de reference
	 */
	private function initItems() {
		
	}
	
	/**
	 * callBack appelé lors du click sur un onglet
	 * et initialise set propriété du popin en fonction
	 * @param	pTarget le bouton cliqué
	 */
	private function onTabSelected(pId:Int):Void{
		SoundManager.getSound("click1").play();
		currentIndex = pId;
	}
	
	private function onItemSelected(pTarget:EventTarget):Void {
		SoundManager.getSound("click1").play();
	}
	
	private function getIdFromEvent(pTarget:EventTarget):Int{
		var lName = pTarget.target.name;
		var lIdButtonChar:String = lName.charAt(lName.length - 1);
		return Std.parseInt(lIdButtonChar);
	}
	
	private function destroyAllChildInContainer(pContainer:SmartComponent) {
		if (pContainer == null) return;
		var lChild:DisplayObject;
		while (pContainer.children.length > 0) {
			lChild = pContainer.getChildAt(0);
			if (lChild == null) return;
			pContainer.removeChild(lChild);
			lChild.destroy();
		}
	}
	
	
	

}