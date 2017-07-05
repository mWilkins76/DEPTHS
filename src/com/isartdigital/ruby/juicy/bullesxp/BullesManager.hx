package com.isartdigital.ruby.juicy.bullesxp;
import com.isartdigital.ruby.game.sprites.elements.Building;
import com.isartdigital.ruby.game.world.Region;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.iso.IsoManager;
import com.isartdigital.utils.game.pooling.PoolObject;
import pixi.core.display.Container;
import pixi.core.math.Point;

	
/**
 * ...
 * @author Adrien Bourdon
 */
class BullesManager 
{
	
	/**
	 * instance unique de la classe BullesManager
	 */
	private static var instance: BullesManager;
	
	private var listBulle:Map<String, Array<Bulle>> = new Map<String, Array<Bulle>>();
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): BullesManager {
		if (instance == null) instance = new BullesManager();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		
	}
	
	public function initBulles(pXp:Int, pParent:Building):Void
	{
		var lNumberBulles:Int = 2 + Math.round(Math.random() * 2 * (pParent.localWidth / 2));
		var lBulle:Bulle;
		var lBulleArray:Array<Bulle> = new Array<Bulle>();
		for (i in 2...(lNumberBulles + 1))
		{
			lBulle = new Bulle();
			GameStage.getInstance().getInfoBulleContainer().addChild(lBulle);
			lBulle.position = getRandomPosition(IsoManager.getGlobalPositionOfBuilding(pParent));
			lBulle.init();
			lBulle.start();
			lBulle.idBuilding = pParent.instanceID;
			lBulleArray.push(lBulle);
		}
		listBulle.set(pParent.instanceID, lBulleArray);

	}
	

	
	public function getRandomPosition(pPoint:Point):Point
	{
		var sign:Int = Math.random() <= 0.5? 1 : -1;
		pPoint.x += sign * Math.random() * 200;
		pPoint.y += sign * Math.random() * 100;
		return pPoint;
	}
	
	public function destroyGroupOfBulles(pIdBuilding:String, ?pFastDestroy:Bool = false):Void
	{
		var lArray:Array<Bulle> = listBulle.get(pIdBuilding);
		if (lArray == null) return;
		for (i in 0...lArray.length)
		{
			if (lArray[i] != null)
			{
				if (!pFastDestroy) lArray[i].setModePrepareToExplose(false);
				else lArray[i].destroy();
				
			}
		}
		lArray = null;
		listBulle.remove(pIdBuilding);
		
		if (!pFastDestroy)cast(PoolObject.elementList.get(pIdBuilding).instance, Building).onBulleExplose();
	}
	
	public function isBuildingHasBulles(pBuildingID:String):Bool
	{
		if (listBulle == null || pBuildingID == null) return false;
		if(listBulle.exists(pBuildingID)) return true;
		return false;
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}