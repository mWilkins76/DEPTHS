package com.isartdigital.ruby.utils;
import pixi.core.math.Point;

/**
 * ...
 * @author Julien Fournier
 */
class BezierCurve
{

	private  function new() 
	{
		
	}
	
	public static function customEase(pTime:Float):Float
	{
		var lPoint:Point = calculCurve(new Point(0, 0), new Point(0.91, 0.1), new Point(0.16, 0.99), new Point(1, 1), pTime);
		return lPoint.y;
	}
	
	/**
	 * 
	 * @param	pA : point de départ
	 * @param	pB : point de tangeante à pA
	 * @param	pC : point de tangeante à pD
	 * @param	pD : point d'arrivée
	 * @param	time compris entre 0 et 1
	 * @return le point sur la courbe de bézier à l'instant time
	 */
	public static function calculCurve(pA:Point,pB:Point,pC:Point,pD:Point,t:Float, ?pCustomEase:Bool=false):Point
	{
		var lPoint:Point = new Point(0, 0);
		if (pCustomEase) t = customEase(t);	
		
		var s:Float = 1 - t;

		lPoint.x = s * s * s * pA.x + 3 * t * s * s * pB.x + 3 * t * t * s * pC.x + t * t * t * pD.x;
		lPoint.y = s * s * s * pA.y + 3 * t * s * s * pB.y + 3 * t * t * s * pC.y + t * t * t * pD.y;
		return lPoint;
	}
	
}