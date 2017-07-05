package com.isartdigital.utils.game.clipping;
import com.isartdigital.utils.game.clipping.IClippable.Element;
import com.isartdigital.utils.save.ElementSave;
import haxe.ds.ObjectMap;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;

	
/**
 * Gestion de la grille de clipping
 * @author Adrien Bourdon
 */
class CellManager 
{
	
	/**
	 * instance unique de la classe CellManager
	 */
	private static var instance: CellManager;
	
	//grille du niveaux
    public static var level:Map<Int, Map<Int, Cell>>;
	public var listElementSave:Map<String, Element>;
	
	public var xMin:Int;
	public var xMax:Int;
	public var yMin:Int;
	public var yMax:Int;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): CellManager {
		if (instance == null) instance = new CellManager();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		
	}
	
	/**
	 * initialise la grille de cellule en fonction de la taille du niveaux
	 */
	public function initGrid(pLevelContainer:Rectangle):Void 
	{		
		level = new Map<Int, Map<Int, Cell>>();
		var lMap:Map<Int , Cell>;
		var lCell:Cell;
		xMin = Math.floor(pLevelContainer.x);
		yMin = Math.floor(pLevelContainer.y);
		xMax = Math.ceil((xMin + pLevelContainer.width) / ClippingManager.CELL_WIDTH);
		yMax = Math.ceil((yMin + pLevelContainer.height) / ClippingManager.CELL_HEIGHT);
		for (i in xMin...xMax) 
		{
			lMap = new Map<Int, Cell>();
			for (j in yMin...yMax) 
			{
				lCell = new Cell();
				lMap.set(j, lCell);
			}
			level.set(i, lMap);
		}
	}
	
	/**
	 * Ajoute un ElementSave aux cell qui vont le contenir
	 * @param	pElem : ElementSave
	 */
	public function setCell(pElem:Element)
	{
		var lArray:Array<Point> = getCells(pElem.globalX, pElem.globalY , pElem.width, pElem.height);
		var lPoint:Point;
		var lCell:Cell;
		
		for (i in 0...lArray.length)
		{
			lPoint = lArray[i];
			if (isCellExist(lPoint) == null) increaseGrid(cast(lPoint.x, Int), cast(lPoint.y, Int));
			lCell = level.get(cast(lPoint.x, Int)).get(cast(lPoint.y, Int));
			lCell.add(pElem.instanceID);
		}
	}
	
	/**
	 * retourne les cell qui vont contenir un element;
	 * @param	pX : position x de l'element
	 * @param	pY : position y de l'element
	 * @param	pWidth : longeur de l'element
	 * @param	pHeight : hauteur de l'element
	 * @return un tableau de points pour chaque index de cell
	 */
	private function getCells(pX:Float, pY:Float, pWidth:Float, pHeight:Float):Array<Point>
	{
		var lArray:Array<Point> = new Array<Point>();
		var lXmin:Int = Math.floor(pX / ClippingManager.CELL_WIDTH);
		var lYmin:Int = Math.floor(pY / ClippingManager.CELL_HEIGHT);
		var lPoint:Point = new Point(lXmin, lYmin);
		
		var lNumberCellX:Int = checkNextCell(lXmin, ClippingManager.CELL_WIDTH, lXmin + pWidth);
		var lNumberCellY:Int = checkNextCell(lYmin, ClippingManager.CELL_HEIGHT, lYmin + pHeight);
		
		for (i in 0...lNumberCellX + 1) 
		{
			for (j in 0...lNumberCellY + 1) 
			{
				lPoint = new Point(lXmin + i, lYmin + j);
				lArray.push(lPoint);
			}			
		}				
		return lArray;
	}
	
	
	/**
	 * verifie la grille contient une Cell au coordonnée d'un point
	 * @param	pPoint : coordonnée de la Cell
	 * @return  la Cell si elle exist, sinon null
	 */
	private function isCellExist(pPoint:Point):Cell
	{
		if (level.get(cast(pPoint.x, Int)) == null) return null;
		return level.get(cast(pPoint.x, Int)).get(cast(pPoint.y, Int));
	}
	
	/**
	 * agrandit la grille en créant une nouvelle Cell au coordonnée pX et pY
	 * @param	pX 
	 * @param	pY
	 */
	private function increaseGrid(pX:Int, pY:Int):Void 
	{
		if (level.get(pX) == null) 
		{
			var lMap:Map<Int, Cell> = new Map<Int ,Cell>();
			level.set(pX, lMap);		
		}
		if (level.get(pX).get(pY) == null)
		{
			var lCell = new Cell();
			level.get(pX).set(pY, lCell);
		}
		changeGridSize(pX, pY);
	}
	
	
	/**
	 * change les valeurs xMin, xMax, yMin, yMax représentant la taille de la grille
	 * si besoin
	 * @param	pX 
	 * @param	pY
	 */
	private function changeGridSize(pX:Int, pY:Int):Void 
	{
		if (pX < xMin) xMin = pX;
		else if (pX > xMax) xMax = pX;
		
		if (pY < yMin) yMin = pY;
		else if (pY > yMax) yMax = pY; 
	}
	
	/**
	 * compte combien il y a de segment d'une certaine taille entre 2 points
	 * @param	pX : point de depart
	 * @param	pStepsSize : taille d'un segment
	 * @param	pDistance : point d'arrivé
	 * @return nombre de segment
	 */
	private function checkNextCell(pX:Int, pStepsSize:Int, pDistance:Float):Int
	{
		var lNumberCell:Int = 0;
		if (pX + pStepsSize <= pDistance) 
		{
			lNumberCell = checkNextCell(pX + pStepsSize, pStepsSize, pDistance) + 1;
		}		
		return lNumberCell;
	}
		
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}