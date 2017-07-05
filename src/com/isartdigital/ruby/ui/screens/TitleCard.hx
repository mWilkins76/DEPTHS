package com.isartdigital.ruby.ui.screens;

import com.isartdigital.ruby.game.GameManager;
import com.isartdigital.ruby.preloadgame.PreloadMiniGame;
import com.isartdigital.ruby.ui.popin.Confirm;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.Screen;
import haxe.Http;
import js.Browser;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pixi.interaction.EventTarget;

	
/**
 * Exemple de classe héritant de Screen
 * @author Mathieu ANTHOINE
 */
class TitleCard extends Screen 
{
	private var background:Sprite;
	
	/**
	 * instance unique de la classe TitleCard
	 */
	private static var instance: TitleCard;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): TitleCard {
		if (instance == null) instance = new TitleCard();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	public function new() 
	{
		super();
		background = new Sprite(Texture.fromImage(Config.url(Config.assetsPath + "SplashScreen.png")));
		background.anchor.set(0.5, 0.5);
		addChild(background);
		interactive = true;
		buttonMode = true;
		
		
		
		
		
	}
	
	private function onClick (pEvent:EventTarget): Void {
		SoundManager.getSound("click").play();
		//UIManager.getInstance().openPopin(Confirm.getInstance());

	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}