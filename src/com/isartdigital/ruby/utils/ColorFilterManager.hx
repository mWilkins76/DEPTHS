package com.isartdigital.ruby.utils;
import com.isartdigital.utils.game.GameObject;
import pixi.core.display.DisplayObject;
import pixi.filters.color.ColorMatrixFilter;
import pixi.flump.Movie;


typedef ColorFilterParams=
{
	/**
	 * red/green/blue/orangeblack/white
	 */
	var colorToApply:String;
	var colorAmount:Float;
	var duration:Int;
}

/**
 * ...
 * @author Julien Fournier
 */
class ColorFilterManager 
{
	
	/**
	 * instance unique de la classe ColorFilter
	 */
	private static var instance: ColorFilterManager;
	

	private var colorMatrix:Array<Float> = new Array<Float>();


	private var listElements:Array<GameObject> = new Array<GameObject>();
	private var listParams:Array<ColorFilterParams> = new Array<ColorFilterParams>();
	
	private var currentElement:Int;


	public var tint:Int;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): ColorFilterManager {
		if (instance == null) instance = new ColorFilterManager();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		
	}
	/**
	 * Applique un filtre de couleur à un GameObject grâce à une liste de Paramètre de réglages
	 * @param	pTarget
	 * @param	pParams
	 */
	public function applyFilter(pTarget:GameObject, pParams:ColorFilterParams)
	{
		listElements.push(pTarget);
		listParams.push(pParams);
	}
	
	public function doAction():Void
	{
		if (listElements.length <= 0) return;
		
		for (element in 0...listElements.length) 
		{
			currentElement = element;
			if (listParams[element].duration != 0)	listParams[element].colorAmount -= 0.01;
			 

			if (listParams[element].colorToApply == "red") colorMatrix = [1, 0, 0, listParams[element].colorAmount, 0,
																		0, 1, 0, 0, 0,
																		0, 0, 1, 0, 0,
																		0, 0, 0, 1, 0];
																		
			if (listParams[element].colorToApply  == "green") colorMatrix = [0, 0, 0, 0, 0, 
												listParams[element].colorAmount, 1, 0, 0, 0, 
																			1, 0,0 , 0, 0,
																			listParams[element].colorAmount, 0, 0, 0, 0];
																			
			if (listParams[element].colorToApply  == "blue") colorMatrix = [1, 0, 0, 0, 0,
																			0, 1, 0, 0, 0, 
											listParams[element].colorAmount, 1, 1, 0, 0,
																			0, 0, 0, 0, 0];
																			
			if (listParams[element].colorToApply  == "pink") colorMatrix = [listParams[element].colorAmount, 1, 0, 0, 0, 
																			listParams[element].colorAmount, 0, 0, 0, 0, 
																			listParams[element].colorAmount, 1, 0, 0, 0,
																			listParams[element].colorAmount, 1, 0, 0, 0];
																			
			if (listParams[element].colorToApply  == "white") colorMatrix = [1, 0, 0, 0, listParams[element].colorAmount,
																		0, 1, 0, 0, listParams[element].colorAmount,
																		0, 0, 1, 0, listParams[element].colorAmount,
																		0, 0, 0, 0, listParams[element].colorAmount];

			if (listParams[element].colorToApply == "black") colorMatrix = [0, 0, 0, 0, 0,
																		0, 0, 0, 0, 0,
																		0, 0, 0, 0, 0,
																		1, 1, 0, 0, 0];																				
																			
			if (listParams[element].colorToApply == "orange") colorMatrix = [listParams[element].colorAmount, 0.5, 0.25, 0.25, listParams[element].colorAmount,
																		listParams[element].colorAmount, 0.4, 0, 0.19, listParams[element].colorAmount,
																		0, 0, 0, 0, 0,
																		1, 0, 0, 0, 0];

			listElements[element].colorFilter.matrix = colorMatrix;
			listElements[element].filters = [listElements[element].colorFilter];
				
			if (listParams[element].colorAmount <= 0)
			{	
				resetColor();
				return;
			}
				
			
		}
	}
	
	/**
	 * supprime le filtre
	 */
	public function resetColor():Void
	{
		if (currentElement == null) return;
		listElements[currentElement].colorFilter.reset();
		listElements[currentElement].filters = null;
		listElements.remove(listElements[currentElement]);
		listParams.remove(listParams[currentElement]);
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}