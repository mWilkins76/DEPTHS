package com.isartdigital.ruby.preloadgame;

import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.game.pooling.PoolObject;
import com.isartdigital.utils.ui.smart.UIMovie;
import pixi.flump.Movie;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author Michael Wilkins
 */
class Helix extends UIMovie

{

	private var animation:Movie;
	
	private var isStopped:Bool = false;
	
	public function new(?pAsset:String) 
	{
		super(pAsset);
		animation = cast(anim, Movie);
		start();
	}
	override public function start():Void 
	{
		super.start();
		Main.getInstance().on(EventType.GAME_LOOP, gameLoop);
	}
	
	public function isFinished():Bool {
	
		
		if (animation.currentFrame >= animation.totalFrames-1) {
			return true;
		}
		else return false;
		
	}
	
	public function update (pProgress:Float): Void {
		var lProgession:UInt = Math.round((200 * pProgress / 100));
		
		if (lProgession <= animation.currentFrame) {
			animation.stop();
			isStopped = true;
		}
		
		if (isStopped && lProgession > animation.currentFrame) {
			animation.play();
			isStopped = false;
		}
		
		
	}
	
	private function gameLoop(pEvent:EventTarget):Void {
	
		if (isFinished()) {
			animation.stop();
			Main.getInstance().isAnimLoadingDone = true;
			Main.getInstance().verifyLaunch();
			Main.getInstance().off(EventType.GAME_LOOP, gameLoop);
		}
	}
	
}