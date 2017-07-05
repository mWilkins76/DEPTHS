package com.isartdigital.ruby.ui.items;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.sprites.Sprite;

	
/**
 * ...
 * @author Jordan Dachicourt
 */
class ItemAsset extends SmartComponent
{
	
	/**
	 * instance unique de la classe ItemAsset
	 */
	private static var instance: ItemAsset;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): ItemAsset {

		if (instance == null) instance = new ItemAsset();
		return instance;
	}
		/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(pID);
		
	}
	
	
	public function getItemAsset(pName:String):UISprite {	
		var lAsset:UISprite = cast(getChildByName("Shop_spriteItemAsset_SC5"), UISprite);
		return lAsset;
	}
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}