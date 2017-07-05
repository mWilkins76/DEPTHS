package com.isartdigital.ruby.ui.popin.codex;

import com.isartdigital.ruby.game.sprites.elements.aliens.Alien;
import com.isartdigital.ruby.game.world.MapInteractor;
import com.isartdigital.ruby.ui.ftue.FTUEManager;
import com.isartdigital.ruby.ui.items.switchItems.CodexSwitchItem;
import com.isartdigital.ruby.ui.items.switchItems.CodexSwitchTab;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;
import pixi.core.math.Point;

	
/**
 * ...
 * @author Michael Wilkins
 */
class Codex extends Menu 
{
	
	/**
	 * instance unique de la classe Codex
	 */
	private static var instance: Codex;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Codex {
		if (instance == null) instance = new Codex();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(pID);
		modal = true;
	}
	
	override public function open():Void 
	{
		super.open();
		MapInteractor.getInstance().modalPopinOpened = true;
	}
	
	override public function close():Void 
	{
		super.close();
		MapInteractor.getInstance().modalPopinOpened = false;
	}
	/**
	 * Initialise le BuildingMenu, recupere tout les container
	 */
	override private function init()
	{

		super.init();
		initTab(CodexSwitchTab);
		initItems();
		ftueRegister();
		
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
	
	override function initOffsetBetweenItems() 
	{
		super.initOffsetBetweenItems();
		var lFirstItemNextLine:Point = itemContainer.getChildByName(ITEM +" #6").position;
		offsetItem.y = lFirstItemNextLine.y - firstItemPosition.y;
	}
	
	/**
	 * Créer les items et les places
	 */
	public function updateItems() {
		destroyAllChildInContainer(itemContainer);
		var currentLine:Int = 0;
	
		
		for (i in 0 ... CodexData.getInstance().listXeno.length) {
		
			if (i > 0 && i % 6 == 0)
				currentLine++;
				
			var currentItem = new CodexSwitchItem();
			itemContainer.addChild(currentItem);
			currentItem.setInfo(CodexData.getInstance().listXeno[i]);
			currentItem.x = offsetItem.x * i%6;
			currentItem.y = offsetItem.y * currentLine;
			currentItem.id = i;
			FTUEManager.register(currentItem);
		}		
	}
	
	public function updateItemsByTypes(pType:String, ?pType2:String = ""):Void
	{
		destroyAllChildInContainer(itemContainer);
		var counter:Int = 0;
		var currentLine:Int = 0;
		
		for (i in 0 ... CodexData.getInstance().listXeno.length) 
		{
			if (CodexData.getInstance().listXeno[i].type == pType || CodexData.getInstance().listXeno[i].type == pType2)
			{
				if (counter > 0 && counter % 6 == 0) currentLine++;				
				var currentItem = new CodexSwitchItem();
				itemContainer.addChild(currentItem);
				currentItem.setInfo(CodexData.getInstance().listXeno[i]);
				currentItem.x = offsetItem.x * i%6;
				currentItem.y = offsetItem.y * currentLine;
				currentItem.id = i;
				FTUEManager.register(currentItem);
				counter++;
			}
		}		
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}