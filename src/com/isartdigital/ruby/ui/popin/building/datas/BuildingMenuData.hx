package com.isartdigital.ruby.ui.popin.building.datas;
import com.isartdigital.ruby.game.sprites.elements.ElementType;

	
/**
 * ...
 * @author Jordan Dachicourt
 */
class BuildingMenuData 
{
	
	/**
	 * instance unique de la classe BuildingMenuData
	 */
	private static var instance: BuildingMenuData;
	
	public var datas:Array<Array<BuildingMenuParams>>;
	public var foo:Float;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): BuildingMenuData {
		if (instance == null) instance = new BuildingMenuData();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		
	}
	
	public function init(pBuildingMenuData: Dynamic) {
		datas = pBuildingMenuData;
	}
	
	
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}