package com.isartdigital.ruby.ui;

import com.isartdigital.ruby.preloadgame.LoadingBar;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.ui.Screen;
import pixi.core.sprites.Sprite;
import pixi.core.text.Text;
import pixi.core.textures.Texture;

/**
 * Preloader Graphique principal
 * @author Mathieu ANTHOINE
 */
class GraphicLoader extends Screen 
{
	
	/**
	 * instance unique de la classe GraphicLoader
	 */
	private static var instance: GraphicLoader;

	//private var loaderBar:LoadingBar = LoadingBar.getInstance();
	private var pourcentage:Text;
	private var title:Text;
	private var ressourceText:Text;
	private static inline var MARGIN_TOP: Float = 500;
	


	public function new() 
	{
		super();
		//var lBg:Sprite = new Sprite(Texture.fromImage(Config.url(Config.assetsPath+"preload_bg.png")));
		//lBg.anchor.set(0.5, 0.5);
		//addChild(lBg);
		//
		//loaderBar = new Sprite (Texture.fromImage(Config.url(Config.assetsPath+"preload.png")));
		//loaderBar.anchor.y = 0.5;
		//loaderBar.x = -loaderBar.width / 2;
		//addChild(loaderBar);
		//loaderBar.scale.x = 0;
		//
		//pourcentage  = new Text(" ", { font : '50px Arial black', fill : 0xFFFFFF, align : 'center' } );
		//pourcentage.anchor.set(0.5, 0.5);
		//pourcentage.y = MARGIN_TOP/2-150;
		//addChild(pourcentage);
		//
		//ressourceText  = new Text(" ", { font : '50px Arial black', fill : 0xFFFFFF, align : 'center' } );
		//ressourceText.anchor.set(0.5, 0.5);
		//ressourceText.y = MARGIN_TOP/2.5;
		//addChild(ressourceText);
				
		//addChild(loaderBar);
		//loaderBar.start();
		//loaderBar.scale.x = 1.5;
		//loaderBar.scale.y = 1.5;
		
	}
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): GraphicLoader {
		if (instance == null) instance = new GraphicLoader();
		return instance;
	}
	
	
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}