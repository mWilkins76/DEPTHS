package com.isartdigital.ruby.utils;
import com.greensock.TweenMax;
import com.greensock.easing.Back;
import com.isartdigital.ruby.game.controller.Controller;
import com.isartdigital.ruby.utils.ColorFilterManager.ColorFilterParams;
import com.isartdigital.ruby.utils.RessourceEffect;
import com.isartdigital.ruby.ui.hud.Hud;
import com.isartdigital.utils.game.pooling.PoolManager;
import com.isartdigital.utils.game.pooling.PoolObject;
import com.isartdigital.utils.ui.SmartText;
import com.isartdigital.utils.game.GameObject;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject;
import pixi.core.graphics.Graphics;
import pixi.core.math.Point;

typedef RessourcesEffectParams = 
{
	var originalPosition:Point;
	var destinationPosition:Point;
	var whereToAddchild:Container;
	var numObjectsToInstanciate:Int;
	var duration:Float;
	var secondsBtwnaddchilds:Float;
	var speed:Float;
	var animationType:String;
	var ressource:RessourceType;
}

enum RessourceType
{
	SoftCurrency;
	HardCurrency;
	ItemHC0;
	ItemHC1;
    ItemHC2;
	ItemBluePrint;
	ItemBluePrintPart;
	ItemDarkMatter0;
	ItemDarkMatter1;
	ItemDarkMatter2;
	ItemGeneTwo0;
    ItemGeneTwo1;
    ItemGeneTwo2;
    ItemGeneOne0;
    ItemGeneOne1;
    ItemGeneOne2;
	ItemGeneFive0;
	ItemGeneFive1;
	ItemGeneFive2;
	ItemGeneFour0;
	ItemGeneFour1;
	ItemGeneFour2;
	ItemGeneThree0;
	ItemGeneThree1;
	ItemGeneThree2;
}	
/** 
 * ...
 * @author Julien Fournier
 */
class RessourcesEffectManager 
{

	private var element:PoolObject;
	private var bubble:PoolObject;
	private var params:RessourcesEffectParams;
	private var isAnimEnd:Bool = false;
	private var container:Container;
	private var originalPos:Point;
	private var destinationPosition:Point;
	
	
	
	
	/**
	 * instance unique de la classe RessourcesEffectManager
	 */
	private static var instance: RessourcesEffectManager;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): RessourcesEffectManager {
		if (instance == null) instance = new RessourcesEffectManager();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		
	}
	
	/**
	 * Initialise l'effet grace a une liste de params
	 * @param	pParams
	 */
	public function SetEffect(pParams:RessourcesEffectParams):Void
	{		
		params = pParams;
		container = pParams.whereToAddchild;
		originalPos = pParams.originalPosition;
		destinationPosition = pParams.destinationPosition;
		OnStartEffect();
		for (i in 0...pParams.numObjectsToInstanciate) 
		{
			bubble = PoolManager.getFromPool("Bubble");
			bubble.init(null);
			bubble.position.x = pParams.originalPosition.x + Math.random()*30-15;
			bubble.position.y = pParams.originalPosition.y + Math.random() * 30 - 15;
			
			cast(bubble, RessourceEffect).setModeInit(pParams.animationType, pParams.destinationPosition, pParams.ressource,new Point(bubble.position.x - pParams.originalPosition.x, bubble.position.y - pParams.originalPosition.y));
			pParams.whereToAddchild.addChild(bubble);
							
			var lParticle:Container = ParticleManager.getInstance().createParticle("bubble", ["smoke01"], 5000);
			lParticle.position = bubble.position;
			container.addChild(lParticle);
			
		}
	}
	
	/**
	 * Définistion de l'effet de couleur à appliquer au démarage de l'animation
	 */
	public function OnStartEffect():Void
	{
		var lParticle:Container = ParticleManager.getInstance().createParticle("smoke", ["smoke01","bubble"], 5000);
		lParticle.position = originalPos;
		container.addChild(lParticle);
	}
	/**
	 * Définistion de l'effet de couleur à appliquer à la fin de l'animation
	 */
	public function OnEffectEnd():Void
	{
		var lParticle2:Container = ParticleManager.getInstance().createParticle("explosionStars", ["smoke03","stars1","stars3","stars3"], 5000);
		lParticle2.position = destinationPosition;
		container.addChild(lParticle2);
	}
	
	public function getAnimEnd():Bool
	{
		return isAnimEnd;
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}
	
	

}