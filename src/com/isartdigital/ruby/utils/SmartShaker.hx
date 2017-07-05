package com.isartdigital.ruby.utils;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.sounds.SoundManager;
import pixi.core.display.DisplayObject;
import pixi.core.math.Point;


typedef ShakerParams = 
{
	var originalPosition:Point;
	var smoothness:Float;
	var amplitude:Float;
	var duration:Float;
	var xQuantity:Float;
	var yQuantity:Float;
	var fadeOut:Float;
	var randomShake:Bool;
	@:optional var sound:String;
}

/**
 * Class qui Shake un élément et diffuse un son
 * @author Julien Fournier
 */
class SmartShaker 
{
	
	/**
	 * instance unique de la classe SmartShake
	 */
	private static var instance: SmartShaker;
	
	private static inline var MIN_RAND_SHAKE:Float = 0.8;
	private static inline var MAX_RAND_SHAKE:Float = 1;
	private var shaker:Point = new Point(0, 0);

	public var listElementToShake:Array<DisplayObject> = new Array<DisplayObject>();
	public var listParams:Array<ShakerParams> = new Array<ShakerParams>();
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): SmartShaker {
		if (instance == null) instance = new SmartShaker();
		return instance;
	}

	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		
	}

	/**
	 * Configure et lance le Shaker
	 * @param	pElem2Shake
	 * @param	pParams
	 */
	public function SetShaker(pElem2Shake:DisplayObject, pParams:ShakerParams):Void
	{
		for (element in 0...listElementToShake.length) 
		{
			if (pElem2Shake ==  listElementToShake[element])
			{
				return;
			}

		}
		
		listElementToShake.push(pElem2Shake);
		listParams.push(pParams);
		if (pParams.sound != null) SoundManager.getSound(pParams.sound).play();

	}

	public function doAction():Void
	{
		if (listElementToShake.length == 0) return;

		for (element in 0...listElementToShake.length) 
		{
			listParams[element].duration--;
			
			if (listParams[element].duration <= 0) 
			{

				listElementToShake[element].position.set(listParams[element].originalPosition.x,listParams[element].originalPosition.y);

				listElementToShake.remove(listElementToShake[element]);
				listParams.remove(listParams[element]);
				
				return;
			}
			
			shaker.x = listParams[element].xQuantity * ((MIN_RAND_SHAKE + Math.random() * (MAX_RAND_SHAKE - MIN_RAND_SHAKE)) * Math.cos(listParams[element].duration * 2 * Math.PI / listParams[element].smoothness) * listParams[element].amplitude);
			shaker.y = listParams[element].yQuantity * ((MIN_RAND_SHAKE + Math.random() * (MAX_RAND_SHAKE - MIN_RAND_SHAKE)) * Math.sin(listParams[element].duration * 2 * Math.PI / listParams[element].smoothness) * listParams[element].amplitude);
			
			listParams[element].amplitude *= listParams[element].fadeOut;
			
			listElementToShake[element].x += shaker.x;
			listElementToShake[element].y += shaker.y;
		}
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		
		instance = null;
	}

}