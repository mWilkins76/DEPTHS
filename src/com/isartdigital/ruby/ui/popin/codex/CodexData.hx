package com.isartdigital.ruby.ui.popin.codex;
import com.isartdigital.ruby.game.specialFeature.managers.SpecialFeatureAliens;
import com.isartdigital.ruby.game.sprites.elements.aliens.Alien;
import com.isartdigital.ruby.game.sprites.elements.aliens.AlienEsthetique;
import com.isartdigital.ruby.game.sprites.elements.aliens.alienspaddockable.AlienBuffer;
import com.isartdigital.ruby.game.sprites.elements.aliens.alienspaddockable.AlienProducer;

	
/**
 * ...
 * @author Jordan Dachicourt
 */
class CodexData 
{
	
	/**
	 * instance unique de la classe CodexData
	 */
	private static var instance: CodexData;
	
	public var data:Array<XenoCodexTypedef>;
	
	public var listXeno:Array<XenoCodexTypedef> = new Array<XenoCodexTypedef>();
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): CodexData {
		if (instance == null) instance = new CodexData();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		
	}
	
	public function init(pData:Dynamic) {
		data = pData.xenos;
	}
	
	public function listAllAlienTypesInCodex():Void
	{
		for (buffer in AlienBuffer.bufferTypes)
		{
			listXeno.push(createNewXenoType(buffer.name, "AlienBuffer",buffer.nomenclature));
		}
		
		for (producer in AlienProducer.prodTypes)
		{
			listXeno.push(createNewXenoType(producer.name, "AlienProducer", producer.nomenclature));
		}
		
		
		
		for (foreur in SpecialFeatureAliens.speFeatTypes)
		{
			listXeno.push(createNewXenoType(foreur.name, "AlienForeur", foreur.nomenclature));
		}
		
		countAlienByName();
		
	}
	
	public function countAlienByName():Void
	{
		for (xeno in listXeno)
		{
			xeno.quantity = Alien.countAliensByName(xeno.name);
		}
	}
	
	private function createNewXenoType(pName:String, pType:String, ?pNomenclature:String = "", ?pQuantity:Int = 0):XenoCodexTypedef 
	{
		var lXeno:XenoCodexTypedef = 
		{
			name:pName,
			quantity:pQuantity,
			type:pType,
			nomenclature:pNomenclature
		}
		return lXeno;
	}
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		//listAllAlienTypesInCodex = [];
		instance = null;
	}

}