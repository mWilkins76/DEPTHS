package com.isartdigital.ruby.preloadgame;
import com.isartdigital.ruby.juicy.bullesxp.Bulle;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.pooling.PoolObject;
import com.isartdigital.utils.system.DeviceCapabilities;
import com.isartdigital.utils.ui.SmartText;
import pixi.core.math.Point;
import pixi.interaction.EventTarget;

	
/**
 * ...
 * @author Adrien Bourdon
 */
class PreloadMiniGame 
{
	
	private var counter:Int = 0;
	

	/**
	 * instance unique de la classe PreloadMiniGame
	 */
	private static var instance: PreloadMiniGame;
	public static var scoreText:SmartText;

	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): PreloadMiniGame {
		if (instance == null) instance = new PreloadMiniGame();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		
	}
	
	public function start():Void 
	{
		counter = 30;
		scoreText = new SmartText(GameStage.getInstance(), 300, 300, 100, "Arial Black", "white", "center", true, "blue", 0, 100);
		GameStage.getInstance().addChild(scoreText);
		scoreText.position = new Point(0 , 50);
		
		Main.getInstance().on(EventType.GAME_LOOP, gameLoop);
	}
	
	public function gameLoop (pEvent:EventTarget): Void
	{
		counter++;
		if (counter >= 30)
		{
			var lBulle:PreloadBulle = new PreloadBulle();
			GameStage.getInstance().addChild(lBulle);
			lBulle.position = getRandomPosition();
			lBulle.init();
			lBulle.start();
			counter = 0;
			if (PreloadBulle.list.length >= 20) 
			{
				PreloadBulle.list[0].destroy();
			}
		}
		for (i in 0...PoolObject.activeObjectList.length){
			if (PoolObject.activeObjectList[i] == null) continue;	
			PoolObject.activeObjectList[i].doAction();
		}
		
		
		
	}
	
	private function getRandomPosition():Point
	{
		var lPoint:Point = new Point(0, 0);
		lPoint.x = Math.random() * 1500;
		lPoint.y = Math.random() * 1500;
		return lPoint;
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		Main.getInstance().off(EventType.GAME_LOOP, gameLoop);
		if (scoreText != null) scoreText.destroyTimer();
		if (scoreText != null) scoreText.destroy();
		var i = PreloadBulle.list.length;
		while (PreloadBulle.list.length > 0) 
		{
			i--;
			PreloadBulle.list[i].destroy();
		}

		instance = null;
	}

}