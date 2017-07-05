package com.isartdigital.ruby.game.specialFeature.managers;
import com.isartdigital.ruby.game.GameManager;
import com.isartdigital.ruby.game.controller.Controller;
import com.isartdigital.ruby.game.specialFeature.aliens.AlienType;
import com.isartdigital.ruby.game.specialFeature.managers.SFGameManager;
import com.isartdigital.ruby.game.specialFeature.tiles.Tile;
import com.isartdigital.ruby.game.specialFeature.tiles.classes.AlienSpawn;
import com.isartdigital.ruby.game.specialFeature.tiles.classes.Clue;
import com.isartdigital.ruby.game.specialFeature.tiles.classes.HardBrick;
import com.isartdigital.ruby.game.specialFeature.tiles.classes.SpecialFeatureItem;
import com.isartdigital.ruby.game.specialFeature.tiles.classes.Lava;
import com.isartdigital.ruby.game.specialFeature.tiles.classes.Walls;
import com.isartdigital.ruby.game.sprites.elements.ElementType;
import com.isartdigital.ruby.game.sprites.elements.aliens.Alien;
import com.isartdigital.utils.game.clipping.IClippable.Element;
import com.isartdigital.utils.game.pooling.PoolManager;
import com.isartdigital.utils.game.pooling.PoolObject;
import com.isartdigital.utils.loader.GameLoader;
import haxe.Json;
import haxe.ds.Vector;
import pixi.core.display.Container;
import pixi.core.math.Point;

typedef Vector3 =
{
	var x:Int;
	var y:Int;
	var z:Int;
}
	
/**
 * ...
 * @author Julien Fournier
 */
class SFGridManager 
{

	public static inline var COLS : Int = 9;
	public static inline var ROWS : Int = 5;
	public static inline var PROPAGATION_COLS:Int = COLS * 2 - 1;
	public static inline var PROPAGATION_ROWS:Int = ROWS * 2 - 1;
	public static inline var CELL_WIDTH : Int = 200;
	public static inline var CELL_HEIGHT : Int = 150;
	
	private static inline var ALIEN_CLASSNAME:String = "Alien";
	private static inline var ALIEN_TYPE_CLASSNAME:String = "AlienType";
	
	private static inline var JSON_MAP_PATH:String = "specialFeatureMaps/Map";
	private static inline var JSON_EXTENSION:String = ".json";
	
	public var propagationGrid:Array<Array<Int>>;
	private var propagationPath:Array<Vector3>;
	public var jsonGrid:Array<Array<Array<Dynamic>>>;

	
	public var globalMousePos:Point;
	public var gridMousePos:Point;
	
	/*public var multiAssetNameList:Array<String> = [
		ElementType.LAVA,
		ElementType.CLUE_EMPTY,
		ElementType.CLUE_RESSOURCE,
		ElementType.CLUE_BLUEPRINT,
		ElementType.HARDBRICK];*/
	
	public static var jSon:Json;
	
	/**
	 * instance unique de la classe Grid
	 */
	private static var instance: SFGridManager;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): SFGridManager {
		if (instance == null) instance = new SFGridManager();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{

	}
	
		

	/**
	 * Initialise la grille logique et la grille de propagation (pathfinding pour le mode skill et le mode move) avec des tableaux vides
	 */
	public function initGrid():Void
	{


		jsonGrid = new Array<Array<Array<Dynamic>>>();
		for (x in 0...COLS) 
		{
			var lArrayCols:Array<Array<Dynamic>> = new Array<Array<Dynamic>>();
			
			for (y in 0...ROWS) 
			{
				var lArrayRows:Array<Dynamic> = new Array<Dynamic>();
				lArrayCols.push(lArrayRows);
			}
			jsonGrid.push(lArrayCols);
		}
		
		propagationGrid = new Array<Array<Int>>();
	
		for (x in 0...PROPAGATION_COLS) 
		{
			propagationGrid.push(new Array<Int>());
			for (y in 0...PROPAGATION_ROWS) 
			{
				//si les deux sont impairs ça retourne 1 (pour éviter les déplacements en diagonales
				// dans la grille logique déédoublée
				propagationGrid[x].push(-1 *(x % 2) * (y % 2));		
			}
		}
		
	}

	/**
	 * Lis le json (specialFeatureMap) et remplie la grille logique avec les bons élements
	 */
	public function initJsonGrid():Void
	{	

		var lInstance:Dynamic;
		var lType:String = null;
		var lX: Int;
		var lY: Int;
		var globalX:Int;
		var globalY:Int;
		var lElement:Element;
		var lIndex:Int;
	
		for (object in Reflect.fields(jSon)) 
		{
			lInstance = Reflect.field(jSon, object);

			lType = Reflect.field(lInstance, "type");
			lX = Std.int(Reflect.field(lInstance, "x"));// - 1;
			lY = Std.int(Reflect.field(lInstance, "y"));// - 1;
			globalX = Std.int(Reflect.field(lInstance, "globalX"));
			globalY = Std.int(Reflect.field(lInstance, "globalY"));
			lIndex = Std.int(Reflect.field(lInstance, "index"));
			
			lElement = 
			{ 
				instanceID : lType,
				type : lType,
				width : CELL_WIDTH, 
				height : CELL_HEIGHT, 
				x : lX,
				y : lY,
				globalX : lX*CELL_WIDTH,
				globalY : lY * CELL_HEIGHT,
				index : lIndex,

			};
			
			if (jsonGrid[lX] == null){
				return;
			}
			if (jsonGrid[lX][lY] != null) jsonGrid[lX][lY].push(lElement);
		}
	}
	
	/**
	 * génére la grille de la special feature en fonction du contenu du Json
	 * @return
	 */
	public function generateGrid():Void
	{
		var lTile:Tile=null;
		var lTileType:String;

		jSon = GameLoader.getContent(JSON_MAP_PATH+SFGameManager.getInstance().currentMap+JSON_EXTENSION);

		initGrid();
		initJsonGrid();
		for (x in 0...COLS) 
		{
			for (y in 0...ROWS)
			{
				for (object in 0...jsonGrid[x][y].length) 
				{

					lTile = cast(PoolManager.getFromPool(jsonGrid[x][y][object].type), Tile);
					lTile.type = jsonGrid[x][y][object].type;
					lTile.index = jsonGrid[x][y][object].index;
					lTile.x = jsonGrid[x][y][object].globalX;
					lTile.y = jsonGrid[x][y][object].globalY;
					lTile.positionInGrid = new Point(x, y);
					
					addTileInRightContainer(lTile);
				}
			}
		}
	}
	
	/**
	 * Génére la grille (dédoublée) de propagation
	 * @param	pAlienType
	 */
	public function generatePropagationGrid(pAlienType:String):Void
	{
		var lCell:Array<Dynamic>;

		for (x in 0...PROPAGATION_COLS) 
		{
			for (y in 0...PROPAGATION_ROWS) 
			{
				propagationGrid[x][y] = -1 * (x % 2) * (y % 2);	
			}
		}
		
		for (x in 0...COLS) 
		{
			for (y in 0...ROWS) 
			{
				lCell = jsonGrid[x][y];
				for (object in lCell) 
				{
					if (object.type.substring(0, 4) == ElementType.CLUE) propagationGrid[2 * x][2 * y] = 1;
					else if (object.type == ElementType.WALL_BOT) 	propagationGrid[2 * x][2 * y + 1] = -1; 	
					else if (object.type == ElementType.WALL_TOP) 	propagationGrid[2 * x][2 * y - 1] = -1;
					else if (object.type == ElementType.WALL_LEFT) 	propagationGrid[2 * x - 1][2 * y] = -1;
					else if (object.type == ElementType.WALL_RIGHT)	propagationGrid[2 * x + 1][2 * y] = -1;
					else if (object.type == ElementType.HARDBRICK) propagationGrid[2 * x][2 * y] = -1;
					else if (object.type == ElementType.LAVA)
					{
						if (pAlienType == ElementType.ALIEN_TANK) propagationGrid[2 * x][2 * y] = 0;
						else propagationGrid[2 * x][2 * y] = -1;
					}
				}
			}
		}
	}

	/**
	 * Push chaque tile dans leur bon container graphique
	 * @param	pTile
	 */
	public function addTileInRightContainer(pTile:Tile):Void
	{
		if (Std.is(pTile, AlienSpawn))
		{
			pTile.start();
			SFTilesManager.getInstance().tileList.push(pTile);
			SFGameManager.getInstance().wallsContainer.addChild(pTile);
		}
		if (Std.is(pTile, Walls)|| Std.is(pTile, Lava))
		{
			pTile.start();
			SFTilesManager.getInstance().tileList.push(pTile);
			SFGameManager.getInstance().wallsContainer.addChild(pTile);
		}
		else if (Std.is(pTile, Clue) || Std.is(pTile, HardBrick))
		{
			pTile.start();
			SFTilesManager.getInstance().tileList.push(pTile);
			SFGameManager.getInstance().blocsContainer.addChild(pTile);
		}
		else if (Std.is(pTile, SpecialFeatureItem))
		{
			pTile.start();
			SFTilesManager.getInstance().tileList.push(pTile);
			SFGameManager.getInstance().ressourcesContainer.addChild(pTile);
		}
		
	}



	
	/**
	 * Calcul du pathfinding de propagation
	 * @param	pAlienPos
	 * @param	pStamina
	 * @param	pfirstTime
	 */
	public function calculatePropagation(pAlienPos:Point, pStamina:Int, ?pfirstTime:Bool=true):Void
	{	
		var lVector3:Vector3; 
		
		if (pfirstTime)
		{
			propagationPath = new Array<Vector3>();
			lVector3 = {
				x:Math.floor(pAlienPos.x),
				y:Math.floor(pAlienPos.y),
				z:pStamina
			}
			propagationPath.push(lVector3);
		}
				
		var deltaX:Int;
		var deltaY:Int;
		var staminaCost:Int;
		var lX:Int;
		var lY:Int;

		for (i in 0...4) 
		{
			deltaX = (1 - i % 2) * (1-Math.floor(i/2)*2); // 1 , 0 , -1 , 0
			deltaY = (1 - (i + 1) % 2) * (1 - Math.floor(i / 2) * 2); // 0 , 1 , 0 , -1
			lX = Math.floor(pAlienPos.x) + deltaX;
			lY = Math.floor(pAlienPos.y) + deltaY;
						
			if (lX < 0 || lX >= PROPAGATION_COLS || lY < 0 || lY >= PROPAGATION_ROWS) continue;

			staminaCost = propagationGrid[lX][lY];

			//on check les cases adjacentes
			lVector3 =	
			{
				x:lX,
				y:lY,
				z:pStamina-staminaCost
			}

			
			if (staminaCost == -1) continue;
			if (lVector3.z < 0) continue;
			if (isInVectorArray(lVector3, propagationPath)) continue;
			else
			{
				propagationPath.push(lVector3);
				calculatePropagation(new Point(lVector3.x, lVector3.y), lVector3.z, false);
			}
		}
	}
	
	/**
	 * Nettoie le tableau de Vector3
	 */
	private function cleanVector3Array():Void
	{
		var lVector:Vector3;
		var lLength:Int = propagationPath.length;
		for (i in 0...lLength) 
		{
			lVector = propagationPath[lLength - 1 - i];
			if (lVector.x % 2 == 1 || lVector.y % 2 == 1) propagationPath.remove(lVector);
		}
		
		for (vector in propagationPath)
		{
			vector.x = Math.floor(vector.x/ 2);
			vector.y  = Math.floor(vector.y / 2);	
		}
	}
	
	/**
	 * Vérifie si un Vector3 se trouve dans le tableau de Vector3
	 * @param	pVector3
	 * @param	pVector3Array
	 * @return
	 */
	private function isInVectorArray(pVector3:Vector3, pVector3Array:Array<Vector3>):Bool
	{
		var result:Bool = false;
		if (pVector3Array.length == 0) return false;
		
		var lVector:Vector3;
		var lLength:Int = pVector3Array.length;
		for (i in 0...lLength) 
		{
			lVector = pVector3Array[lLength - 1 - i];
			if (lVector.x == pVector3.x && lVector.y == pVector3.y)
			{
				if (lVector.z < pVector3.z) pVector3Array.remove(lVector);
				else return true;
			}
		}
		return result;
	}
	
	
	public function getPropagationPath(pAlienType:String, pAlienPos:Point, pStamina:Int):Array<Vector3>
	{
		generatePropagationGrid(pAlienType);
		calculatePropagation(new Point(pAlienPos.x*2,pAlienPos.y*2), pStamina);
		cleanVector3Array();
		return propagationPath;
	}
	
	
	public function checkForRessource(pTarget:Point):Bool
	{
		var jsonList:Array<Dynamic> = jsonGrid[Math.round(pTarget.x)][Math.round(pTarget.y)];
		
		if (jsonList != null)
		{
			for (object in 0...jsonList.length) 
			{
				if (jsonList[object].type.substring(0, 4) == ElementType.ITEM)
				{
					return true;
				}
			}
		}
		return false;
	}


	
	/**
	 * Vérifie le contenu d'une cellule pour savoir si la cellule target contient un mur
	 * @param	pAlienPos
	 * @param	pTarget
	 * @return
	 */
	public function checkWallinNextPos(pAlienPos:Point, pTarget:Point):Bool
	{
		var DeltaX:Int;
		var DeltaY:Int;
		var alienList:Array<Dynamic> = jsonGrid[Math.round(pAlienPos.x)][Math.round(pAlienPos.y)];
		var targetList:Array<Dynamic> = getInstance().jsonGrid[Math.round(pTarget.x)][Math.round(pTarget.y)];
		var direction:String=null;
		DeltaX = Math.floor(pTarget.x - pAlienPos.x);
		DeltaY = Math.floor(pTarget.y - pAlienPos.y);
		
		if (DeltaX != 0) direction = DeltaX == 1 ? "Right": "Left";
		if (DeltaY !=  0) direction = DeltaY == 1 ? "Bot": "Top";
		
		
		for (i in 0...alienList.length) 
		{
			if (alienList[i].type == "Wall"+direction) return true;	
		}
		
		if (DeltaX !=  0) direction = DeltaX == -1 ? "Right": "Left";
		if (DeltaY !=  0) direction = DeltaY == -1 ? "Bot": "Top";
		
		if (targetList != null)
		{
			for (j in 0...targetList.length) 
			{
				if (targetList[j].type == "Wall"+direction) return true;
			}			
		}

		return false;
	}
	
	/**
	 * retourne la position global de la souris par rapport à pContainer
	 * @param	pContainer
	 * @return
	 */
	public function getGlobalMouseCoords(pContainer:Container):Point
	{
		return Controller.getInstance().getPosFrom(pContainer);
	}
	
	/**
	 * retourne les coordonnées globales selon le modèle de la grille
	 * @param	pPos
	 * @return
	 */
	public function getGlobalGridCoords(pPos:Point):Point
	{
		return new Point(pPos.x * CELL_WIDTH, pPos.y * CELL_HEIGHT);
	}
	
	/**
	 * Retourne les coordonnées selon le modèle grille ex:(2,5)
	 * @param	pGlobalPosition
	 * @return
	 */
	public function getGridCoords(pGlobalPosition:Point):Point
	{
		return new Point
			(
				Math.round(pGlobalPosition.x / CELL_WIDTH),
				Math.round(pGlobalPosition.y / CELL_HEIGHT)
			);
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
		
	}

}