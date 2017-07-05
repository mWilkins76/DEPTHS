package com.isartdigital.utils.game.clipping;
import com.isartdigital.ruby.game.sprites.elements.GameElement;
import com.isartdigital.ruby.game.world.World;
import com.isartdigital.utils.game.clipping.IClippable.Element;
import com.isartdigital.utils.game.iso.IsoManager;
import com.isartdigital.utils.game.pooling.PoolManager;
import com.isartdigital.utils.game.pooling.PoolObject;
import com.isartdigital.utils.save.ElementSave;
import pixi.core.display.DisplayObject;
import pixi.core.math.Point;

	
/**
 * Classe Modifiable en fonction du projet 
 * Affichage ou retrait de l'affichage des elements du jeu
 * @author Adrien Bourdon
 */
class DisplayManager 
{
	
	/**
	 * instance unique de la classe DisplayManager
	 */
	private static var instance: DisplayManager;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): DisplayManager {
		if (instance == null) instance = new DisplayManager();
		return instance;
	}
	
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		
	}
	
	/**
	 * Initialise et Start un elements du jeu 
	 * @param   pInstance : nom de l'instance
	 */
	public function displayElement(pInstance:String):Void 
	{
		var lElem:Element = PoolObject.elementList.get(pInstance);
		var lObject:PoolObject = PoolManager.getFromPool(lElem.type);
		//trace("display : " + lElem.type + " : " + lElem.x + " "+lElem.y );
		World.getInstance().getRegion(lElem.regionX, lElem.regionY).layers[1].container.addChild(lObject);
		lObject.init(lElem);
		lObject.start();
		var lPoint:Point = new Point(lElem.x, lElem.y);
		lObject.position = IsoManager.modelToIsoView(lPoint);
	}
	
	/**
	 * retire un element de l'affichage
	 * @param	pInstance : nom de l'instance
	 */
	public function removeElement(pInstance:String):Void 
	{
		for (object in PoolObject.activeObjectList) 
		{
			if (object.instanceID == pInstance) {
				object.dispose();
			}
		}
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}