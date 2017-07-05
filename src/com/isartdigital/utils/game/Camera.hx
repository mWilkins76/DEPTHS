package com.isartdigital.utils.game;

import com.isartdigital.utils.system.DeviceCapabilities;
import pixi.core.display.DisplayObject;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;

/**
 * Classe Camera
 * @author Mathieu ANTHOINE
 */
class Camera
{

	private var render:Dynamic;
	
	public var target (default,null):DisplayObject;
	public var focus (default, null):DisplayObject;
	
	private var inertiaMax:Point = new Point(40, 20);
	private var inertiaMin:Point = new Point(2, 8);
	private var countH:UInt = 0;
	private var delayH:UInt = 30;
	private var countV:UInt = 0;
	private var delayV:UInt = 30;
	
	
	private static inline var MIN_RAND_SHAKE:Float = 0.8;
	private static inline var MAX_RAND_SHAKE:Float = 1;
	private var shakeSmoothness:Float;
	private var shakeFadeOut:Float;
	private var shakeTimer:Float;
	private var shakeAmplitude:Float;
	private var shakeXQuantity:Float;
	private var shakeYQuantity:Float;
	private var cameraShaker:Point = new Point(0, 0);
	private var shaking:Bool = false;
	
	private var previousFrameX:Int = 0;
	private var previousFrameY:Int = 0;
	
	public var hasJustStopped:Bool = false;
	public var canStop:Bool = true;
	
	/**
	 * instance unique de la classe GamePlane
	 */
	private static var instance: Camera;

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Camera {
		if (instance == null) instance = new Camera();
		return instance;
	}	
	
	private function new() 
	{
		
	}
	
	/**
	 * Défini la cible de la caméra
	 * @param	pTarget cible
	 */
	public function setTarget (pTarget:DisplayObject):Void {
		target = pTarget;
	}
	
	public function getTarget():Point
	{
		return new Point(target.x, target.y);
	}
	
	/**
	 * Défini l'élement à repositionner au centre de l'écran
	 * @param	pFocus focus
	 */
	public function setFocus(pFocus:DisplayObject):Void {
		focus = pFocus;
	}
	
	/**
	 * recadre la caméra
	 * @param	pDelay si false, la caméra est recadrée instantannément
	 */
	private function changePosition (?pDelay:Bool = true) :Void {
		
		if (target == null || focus == null) return;
		
		countH++;
		countV++;
		
		var lCenter:Rectangle = DeviceCapabilities.getScreenRect(target.parent);				
		var lFocus:Point = focus.position;//= getFocusCoord();
		
		var lInertiaX:Float = pDelay ? getInertiaX() : 1;
		var lInertiaY:Float = pDelay ? getInertiaY() : 1;
		
		var lDeltaX:Float = (lCenter.x + lCenter.width / 2 - lFocus.x - target.x) /*/ lInertiaX*/;
		var lDeltaY:Float = (lCenter.y + lCenter.height / 2 - lFocus.y - target.y) /*/ lInertiaY*/;
		
		
	
		target.x += lDeltaX;
		target.y += lDeltaY;
		
		var lCurrentframeX : Int = cast(Math.round(target.x), Int);
		var lCurrentframeY : Int = cast(Math.round(target.y), Int);
		
		if (!canStop && hasJustStopped) hasJustStopped = false;
		
		if (lCurrentframeX == previousFrameX && lCurrentframeY == previousFrameY && canStop) {
			hasJustStopped = true;
			canStop = false;
		}
		
		
		
		previousFrameX = lCurrentframeX;
		previousFrameY = lCurrentframeY;
		
		//GameStage.getInstance().getInfoBulleContainer().position.set(target.x, target.y);
		
		if (shaking) 
		{
			updateShake();
			target.x += cameraShaker.x;
			target.y += cameraShaker.y;
		}
		
	}
	
	/**
	 * Shakes the screen
	 * @param	pSmoothness How many frames will it take to the screen to make a move back and forth
	 * @param	pAmplitude How much should the screen go nuts
	 * @param	pDuration How many frames should the shaking last
	 * @param	pFadeOut How shall the shake fadeout : 1 = no fadeout, 0 = shake get canceled
	 * @param	pMoveX Will it only move on X
	 * @param	pMoveY Will it only move on Y
	 */
	public function shakeScreen(pSmoothness:Float = 10, pAmplitude:Float = 20, pDuration:Float = 30, pXQuantity:Float = 1, pYQuantity:Float = 1, pFadeOut:Float = 0.95):Void {
		if (shaking && shakeAmplitude >= pAmplitude) return;
		shaking = true;
		shakeSmoothness = pSmoothness;
		shakeTimer = pDuration;
		shakeAmplitude = pAmplitude;
		shakeFadeOut = pFadeOut;
		shakeXQuantity = pXQuantity;
		shakeYQuantity = pYQuantity;
		
	}
	
	private function updateShake() 
	{
		shakeTimer--;
		if (shakeTimer <= 0) {
			shaking = false;
			return;
		}
		cameraShaker.x = shakeXQuantity * ((MIN_RAND_SHAKE + Math.random() * (MAX_RAND_SHAKE - MIN_RAND_SHAKE)) * Math.cos(shakeTimer * 2 * Math.PI / shakeSmoothness) * shakeAmplitude);
		cameraShaker.y = shakeYQuantity * ((MIN_RAND_SHAKE + Math.random() * (MAX_RAND_SHAKE - MIN_RAND_SHAKE)) * Math.sin(shakeTimer * 2 * Math.PI / shakeSmoothness) * shakeAmplitude);
		
		shakeAmplitude *= shakeFadeOut;
	}
	
	/**
	 * retourne une inertie en X variable suivant le temps
	 * @return inertie en X
	 */
	private function getInertiaX() : Float {
		if (countH > delayH) return inertiaMin.x;
		return inertiaMax.x + (inertiaMin.x-inertiaMax.x)*countH/delayH;
	}

	/**
	 * retourne une inertie en Y variable suivant le temps
	 * @return inertie en Y
	 */	
	private function getInertiaY() : Float {
		if (countV > delayV) return inertiaMin.y;
		return inertiaMax.y + (inertiaMin.y-inertiaMax.y)*countV/delayV;
	}
	
	/**
	 * cadre instantannément la caméra sur le focus
	 */
	public function setPosition():Void {
		GameStage.getInstance().render();
		changePosition(false);
	}
	
	/**
	 * cadre la caméra sur le focus avec de l'inertie
	 */
	public function move():Void {
		changePosition();
	}
	
	/**
	 * remet à zéro le compteur qui fait passer la caméra de l'inertie en X maximum à minimum
	 */
	public function resetX():Void {
		countH = 0;
	}

	/**
	 * remet à zéro le compteur qui fait passer la caméra de l'inertie en Y maximum à minimum
	 */
	public function resetY():Void {
		countV = 0;
	}
	
	/**
	 * retourne les coordonnées du focus dans le repère de la target
	 */
	public function getFocusCoord ():Point {
		return target.toLocal(focus.position, focus.parent);
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}
	
}