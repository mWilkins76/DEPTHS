package com.isartdigital.ruby.game.player;
import com.isartdigital.ruby.ui.hud.Hud;
import com.isartdigital.utils.save.DataBaseAction;

	
/**
 * ...
 * @author Jordan Dachicourt
 */
class Energy extends Currency 
{
	
	private var maxQuantity;
	/**
	 * instance unique de la classe Energy
	 */
	private static var instance: Energy;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Energy {
		if (instance == null) instance = new Energy();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		
	}
	
	public function lessThanMax(pQuantityToAdd:Bool):Bool{
		return quantity+pQuantityToAdd < maxQuantity;
	}
	
	override public function add(pQuantity:Float):Void 
	{
		if (lessThanMax(pQuantity)) {
			super.add(pQuantity);
			DataBaseAction.getInstance().changeEnergy(Player.getInstance().id, quantity);
		}
		
		Player.getInstance().releaseSave();
		Hud.getInstance().update();
	}
	
	public function addMaxEnergy(pMaxEnergy:Int):Void 
	{
		maxEnergy += pMaxEnergy;
		DataBaseAction.getInstance().changeMaxEnergy(id, maxEnergy);
		Player.getInstance().releaseSave();
		Hud.getInstance().update();
	}
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}