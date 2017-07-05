package com.isartdigital.ruby.preloadgame;

import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.clipping.IClippable.Element;
import com.isartdigital.utils.game.pooling.PoolObject;
import pixi.flump.Movie;

/**
 * ...
 * @author Adrien Bourdon
 */
class PreloadBulle extends PoolObject
{

    public static var list:Array<PreloadBulle> = new Array<PreloadBulle>();
	public static var score:Int = 0;

	public function new(?pAsset:String) 
	{
		alpha = 0.1;
		assetName = "Bulle";
		super(assetName);
		interactive = true;
		scale.x = 3;
		scale.y = 3;
	}
	
	override public function init(?pElem:Element = null):Void 
	{
		list.push(this);
		super.init(pElem);
	}
	
	override function setModeNormal():Void 
	{
		on(MouseEventType.CLICK, setModeExplosion);
		on(TouchEventType.TAP, setModeExplosion);
		scale.x = Math.random() * 2 + 2;
		scale.y = Math.random() * 2 + 2;	
		super.setModeNormal();
		setState(DEFAULT_STATE);
	}

	override function doActionNormal():Void 
	{
		PreloadMiniGame.scoreText.refreshText(Std.string(PreloadBulle.score));
		if (cast(anim, Movie).currentFrame >= cast(anim, Movie).totalFrames -2) setState(DEFAULT_STATE);
		super.doActionNormal();
	}
	
	private function setModeExplosion():Void
	{
		setState("Explosion");
		doAction = doActionExplosion;
		score++;
		PreloadMiniGame.scoreText.refreshText(Std.string(PreloadBulle.score));
	}
	
	private function doActionExplosion():Void
	{
		//if (isAnimEnd) {
		if (cast(anim, Movie).currentFrame >= cast(anim, Movie).totalFrames -1) destroy();
	}
	
	override public function destroy():Void 
	{
		list.remove(this);
		off(MouseEventType.CLICK, setModeExplosion);
		off(TouchEventType.TAP, setModeExplosion);
		super.destroy();
	}
	
}