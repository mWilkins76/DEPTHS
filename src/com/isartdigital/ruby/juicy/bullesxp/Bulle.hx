package com.isartdigital.ruby.juicy.bullesxp;

import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.pooling.PoolObject;
import com.isartdigital.utils.sounds.SoundManager;
import pixi.flump.Movie;

/**
 * ...
 * @author Adrien Bourdon
 */
class Bulle extends PoolObject
{
	private var counter:Int;
	public var idBuilding:String;
	private var isFirstBulle:Bool = true;

	public function new(?pAsset:String) 
	{
		super(pAsset);
		interactive = true;
		scale.x = 3;
		scale.y = 3;
	}
	
	override function setModeNormal():Void 
	{
		setState(DEFAULT_STATE);
		scale.x = Math.random() * 1 +3;
		scale.y = Math.random() * 2 +2;
		this.on(MouseEventType.CLICK, setModeExplosion);
		this.on(TouchEventType.TAP, setModeExplosion);
		super.setModeNormal();
	}
	
	override function doActionNormal():Void 
	{
		if (cast(anim, Movie).currentFrame >= cast(anim, Movie).totalFrames -2) setState(DEFAULT_STATE);
		super.doActionNormal();
	}
	
	public function setModePrepareToExplose(?pIsFirst = true):Void
	{
		counter = 0;
		if (!pIsFirst) isFirstBulle = false;
		doAction = doActionPrepareToExplose;
	}
	
	private function doActionPrepareToExplose():Void
	{
		counter++;
		if (counter >= 75) 
		{
			setModeExplosion();
		}
	}
	
	private function setModeExplosion():Void
	{
		setState("Explosion");
		SoundManager.getSound("soundPlayerSwitchMode").play();
		SoundManager.getSound("soundPlayerValidate").play();
		doAction = doActionExplosion;
	}
	
	private function doActionExplosion():Void
	{
		if (cast(anim, Movie).currentFrame >= cast(anim, Movie).totalFrames -1) 
		{
			if(isFirstBulle) BullesManager.getInstance().destroyGroupOfBulles(idBuilding);
			destroy();
		}
	}
	
	override public function destroy():Void 
	{
		this.off(MouseEventType.CLICK, setModeExplosion);
		this.off(TouchEventType.TAP, setModeExplosion);
		super.destroy();
	}
}