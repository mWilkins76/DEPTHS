package com.isartdigital.ruby.ui.popin.shop.datas;
import com.isartdigital.ruby.ui.popin.shop.datas.GainParams.Gain;
import com.isartdigital.ruby.ui.popin.shop.datas.ShopItemParams.Money;

	
/**
 * ...
 * @author Jordan Dachicourt
 */
class ShopData 
{
	
	/**
	 * instance unique de la classe ShopData
	 */
	private static var instance: ShopData;
	
	public var datas:Array<Array<ShopItemParams>>;
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): ShopData {
		if (instance == null) instance = new ShopData();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		
	}
	
	public function init(pShopData: Dynamic) {
		datas = pShopData;
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}