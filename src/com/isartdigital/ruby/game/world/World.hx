package com.isartdigital.ruby.game.world;
import com.isartdigital.ruby.ui.UIManager;
import com.isartdigital.ruby.ui.popin.buyRegion.BuyRegion;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.save.DataBaseAction;
import com.isartdigital.utils.save.RegionSave;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject;
import pixi.core.math.Point;

/**
 * Gestion du monde : manage des régions et récupèration de leurs données
 * @author Michael Wilkins
 */
class World
{

	/**
	 * instance unique de la classe World

	 */
	private static var instance: World;
	public var worldMap:Map<Int, Map<Int, Region>>;
	private var minX:Int;
	private var minY:Int;
	
	public var numberOfRegionUnlocked:Int = 0;
	private static inline var FIRST_REGION_UNLOCK_COST = 30000;
	private static inline var UNLOCK_MULTIPLIER = 3;
	public var unlockRegionCost:Int = FIRST_REGION_UNLOCK_COST;
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): World
	{
		if (instance == null) instance = new World();
		return instance;
	}

	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	public function new()
	{
		worldMap = new Map<Int, Map<Int, Region>>();
		unlockRegion(0, 0);
	}

	/**
	 * unlock une region et créer les regions alentour si elle n'existe pas
	 * @param	pX : index X de la region
	 * @param	pY : index Y de la region
	 */
	public function unlockRegion(pX:Int, pY:Int)
	{
		if (getRegion(pX, pY) == null)
		{
			addRegion(pX, pY);
			getRegion(pX, pY).setActive();
			initContainers(pX, pY);
		}
		else getRegion(pX, pY).setActive();
		if (getRegion(pX + 1, pY) == null) { addRegion(pX + 1, pY) ;  initContainers(pX+1, pY);  }
		if (getRegion(pX, pY + 1) == null) { addRegion(pX, pY +1) ;  initContainers(pX, pY+1);  }
		if (getRegion(pX - 1, pY) == null) { addRegion(pX - 1, pY);  initContainers(pX-1, pY);  }
		if (getRegion(pX, pY - 1) == null) { addRegion(pX , pY -1);  initContainers(pX, pY - 1);  }
		
		if (getRegion(pX - 1, pY - 1) == null) { addRegion(pX - 1, pY - 1);  initContainers(pX - 1,  pY - 1);  }
		if (getRegion(pX + 1, pY + 1) == null) { addRegion(pX + 1, pY + 1);  initContainers(pX + 1, pY + 1);  }
		if (getRegion(pX + 1, pY - 1) == null) { addRegion(pX + 1, pY - 1);  initContainers(pX + 1, pY - 1);  }
		if (getRegion(pX - 1, pY + 1) == null) { addRegion(pX - 1, pY + 1);  initContainers(pX - 1, pY + 1);  }
		
	
		
		
		if(getRegion(pX,pY).unlockPopin != null) UIManager.getInstance().closeRegionPopin(getRegion(pX,pY).unlockPopin);
		
		numberOfRegionUnlocked++;
		calculateUnlockingRegionCost();
		

		//A Rajouter
		//Region.sortContainers();
	}

	/**
	 * initialise les containers de la region
	 * @param	pX coordonnée x de la region
	 * @param	pY coordonnée y de la region
	 */
	public function initContainers(pX:Int, pY:Int):Void
	{
		getRegion(pX, pY).newInitLayer();
		
	}
	
	public function calculateUnlockingRegionCost():Void {
	
		if (numberOfRegionUnlocked == 1) return;
		var lCost:Int = FIRST_REGION_UNLOCK_COST;
		for (i in 1...numberOfRegionUnlocked) {
		
		 lCost = lCost * UNLOCK_MULTIPLIER;
			
		}
		
		unlockRegionCost = lCost;
	}

	/**
	 * Ajoute une region au world et modifier les index minimum si besoin
	 * @param	pPos : position de la region
	 */
	public function addRegion(pX:Int, pY:Int)
	{
		if (getRegion(pX, pY) != null) return;
		var map :Map<Int, Region>;
		var region:Region;
		if (!worldMap.exists(pX))
		{
			map = new Map<Int, Region>();
		}
		else map = worldMap.get(pX);

		if (!map.exists(pY))
		{
			region = new Region(pX, pY);
			map.set(pY, region);
		}
		worldMap.set(pX, map);
	}

	/**
	 * Recupère une region du world
	 * @param	pPos : position de la region
	 */
	public function getRegion(pX:Int, pY:Int):Region
	{
		if (worldMap.get(pX) == null) return null;
		if (worldMap.get(pX).get(pY) == null) return null;
		return worldMap.get(pX).get(pY);
	}

	/**
	 *
	 */
	/*private function getData():Void
	{
		var lWorldArray:Array<RegionSave>  = [];
		for (keyX in worldMap.keys())
		{
			for (keyX in worldMap.keys())
			{
				for (keyY in worldMap.get(keyX).keys())
				{
					var lRegion:RegionSave =
					{
						posX : keyX,
						posY : keyY,
						width : worldMap[keyX][keyY].width,
						height : worldMap[keyX][keyY].height,
						layerSave : worldMap[keyX][keyY].getData()
					}
					lWorldArray.push(lRegion);
				}
			}
		}
	}*/

	//J'ai mis cette fonctio en commentaire, si vous voulez tester si ça fonctionne
	public function getData():Array<RegionSave>
	{
		var lWorldArray:Array<RegionSave>  = [];
		for (keyX in worldMap.keys())
		{
			for (keyY in worldMap.get(keyX).keys())
			{
				var lRegion:RegionSave =
				{
					posX : keyX,
					posY : keyY,
					width : Region.WIDTH,
					height : Region.HEIGHT,
					layerSave : worldMap[keyX][keyY].getData(),
					isActive : worldMap[keyX][keyY].isActive
				}

				lWorldArray.push(lRegion);
			}
		}
		return lWorldArray;
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void
	{
		instance = null;
	}

}