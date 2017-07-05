package com.isartdigital.ruby.utils;
import com.isartdigital.ruby.game.GameManager;
import com.isartdigital.ruby.game.specialFeature.managers.SFGameManager;
import com.isartdigital.ruby.utils.RessourcesEffectManager;
import pixi.core.display.Container;

import com.isartdigital.ruby.utils.RessourcesEffectManager.RessourceType;
import com.isartdigital.ruby.game.sprites.FlumpStateGraphic;
import com.isartdigital.ruby.ui.hud.Hud;
import com.isartdigital.ruby.utils.BezierCurve;
import com.isartdigital.utils.game.pooling.PoolManager;
import com.isartdigital.utils.game.pooling.PoolObject;
import com.isartdigital.utils.sounds.SoundManager;
import pixi.core.math.Point;


/**
 * ...
 * @author Julien Fournier
 */
class RessourceEffect extends PoolObject
{

	private var counter:Int;
	
	private var nextAction:Void->Void;
	
	private static inline var COUNTER_BUBBLE:Int = 100;
	private static inline var COUNTER_CURVE:Int = 30;
	private static inline var COUNTER_EXPLOSION:Int = 100;
	private static inline var COUNTER_DISPERSION:Int = 40;
	
	private static inline var BUBBLEMODE_APLITUDE_X:Float = 0.75;
	private static inline var BUBBLEMODE_SPEED_Y:Int = 2;
	
	private var numLittleBubbleToSpawn:Int = 10;
	
	private static inline var RADIUS_EXPLOSION:Int = 150;
	

	private var ressourceType:RessourceType;
	
	private var finalDestination:Point;
	private var directionDispersion:Point;
	private var originPoint:Point;
	private var bezierA:Point;
	private var bezierB:Point;

	private var soundFlag:Bool = true;
	private var listRessources:Array<RessourceEffect> = new Array<RessourceEffect>();
	private var dispertionCounter:Int;
	public var starsParticle:Container;
	private var container:Container;
	
	//private var lParticle:Container = ParticleManager.getInstance().createParticle("ressources", ["smoke02", "sparks1", "sparks2"], 5000);


	

	public function new(pAsset:String=null) 
	{
		super(pAsset);
	}

	public function initStarsParticle(pX:Float,pY:Float):Void
	{
		if (GameManager.currentMode == GameManager.MODE_SPECIAL_FEATURE) return;
		var counter:Int = 0;
		var counterMax:Int = 60;
		for (i in 0...counterMax) 
		{
			counter++;
			if (counter >= counterMax)
			{
				starsParticle = ParticleManager.getInstance().createParticle("trail", ["stars1"], 500);
				starsParticle.x = pX;
				starsParticle.y = pY;
				addChild(starsParticle);
				counter = 0;
			}
			
		}

	}	
	/**
	 * SETMODES
	 */
	/**
	 * Initialise l'effet avec le type de ressource à afficher, la position de départ, la destination, et l'animation à jouer
	 * @param	pAnimationType
	 * @param	pDestination
	 * @param	pRessourceType
	 * @param	pDirectionDispersion
	 */
	public function setModeInit(pAnimationType:String, pDestination:Point,  pRessourceType:RessourceType,?pDirectionDispersion:Point,?pWhereToAddchildParticles:Container):Void
	{
		counter = 0;
		finalDestination = pDestination;
		ressourceType = pRessourceType;
		var myRessource:PoolObject;
		container = pWhereToAddchildParticles;
		
		if (ressourceType == RessourceType.SoftCurrency)
		{
			myRessource = PoolManager.getFromPool("RessourceSoftCurrency");
			addChild(myRessource);
			myRessource.start();
		}
		else if (ressourceType == RessourceType.HardCurrency)
		{
			myRessource = PoolManager.getFromPool("RessourceHardCurrency");
			addChild(myRessource);
			myRessource.start();
		}
		else{
			myRessource = PoolManager.getFromPool(Std.string(pRessourceType));
			addChild(myRessource);
			myRessource.start();
			
		}

		start();
		
		if (pAnimationType == "bubble") setModeBubble();
		if (pAnimationType == "curve") setModeCurve();
		if (pAnimationType == "dispersionToCurve" && pDirectionDispersion != null) setModeDispersionToCurve(pDirectionDispersion);
		if (pAnimationType == "dispersionToExplosion" && pDirectionDispersion != null) setModeDispersionToExplosion(pDirectionDispersion);
		


		
	}
	

	/**
	 * Mode bubble
	 */
	public function setModeBubble():Void
	{
		doAction = doActionBubble;
		counter = COUNTER_BUBBLE;
		if(!SoundManager.getSound("bubbleUp").playing()) SoundManager.getSound("bubbleUp").play();
	}
	
	/**
	 * Mode Courbe
	 */
	public function setModeCurve():Void
	{
		counter = COUNTER_CURVE;
		originPoint = position.clone();
		
		var direction:Int = originPoint.x < finalDestination.x ? 1: -1; 
		bezierA = new Point(originPoint.x + direction* COUNTER_CURVE*3, originPoint.y+COUNTER_CURVE*3);
		bezierB = new Point(finalDestination.x, finalDestination.y + COUNTER_CURVE);
		doAction = doActionCurve;
		if(!SoundManager.getSound("bubbleCurve").playing()) SoundManager.getSound("bubbleCurve").play();
	}
	
	/**
	 * mode Explosion
	 */
	public function setModeExplosion():Void
	{
		doAction = doActionExplosion;
		counter = COUNTER_EXPLOSION;
		if(!SoundManager.getSound("bubbleExplosion").playing()) SoundManager.getSound("bubbleExplosion").play();
		
		var lParent = parent;
		var lElement:RessourceEffect;
		var radius:Float = 7;
		
		for (i in 0...numLittleBubbleToSpawn) 
		{
			lElement = cast(PoolManager.getFromPool("Bubble"),RessourceEffect);
			lElement.x = x+radius * Math.cos(2 * Math.PI * i / numLittleBubbleToSpawn);
			lElement.y = y+radius * Math.sin(2 * Math.PI * i / numLittleBubbleToSpawn);
			lElement.scale.x /= 3;
			lElement.scale.y /= 3;
			
			lElement.init(null);
			addChild(lElement);
			lElement.dispertionCounter = 15 * i;
			
			lElement.setModeInit("null", finalDestination,ressourceType);
			lElement.originPoint = new Point(position.x,position.y);
			listRessources.push(lElement);
			
		}
		
		parent.removeChild(this);

	}

	/**
	 * Mode dispersion puis Courbe
	 * @param	pDirectionDispertion
	 */
	public function setModeDispersionToCurve(pDirectionDispertion:Point):Void
	{
		counter = COUNTER_DISPERSION;
		doAction = doActionDispertion;
		if(!SoundManager.getSound("bubbleExplosion").playing()) SoundManager.getSound("bubbleExplosion").play();

		directionDispersion = pDirectionDispertion.clone();
		nextAction = setModeCurve;
	}
	
	/**
	 * mode dispersion puis Explosion
	 * @param	pDirectionDispertion
	 */
	public function setModeDispersionToExplosion(pDirectionDispertion:Point):Void
	{
		counter = COUNTER_DISPERSION;
		doAction = doActionDispertion;
		if(!SoundManager.getSound("bubbleExplosion").playing()) SoundManager.getSound("bubbleExplosion").play();

		directionDispersion = pDirectionDispertion.clone();
		nextAction = setModeExplosion;
		
	}	
	

	
	/**
	 * DOACTION
	 */
	
	public function doActionBubble():Void
	{
		var base:Float = 1;
		var amplitude:Float = 0.15;
		
		if(counter-- >0)
		{
			scale.x = base+amplitude * Math.cos(2 * Math.PI * 2 * counter/COUNTER_BUBBLE);
			scale.y = base+amplitude * Math.sin(2 * Math.PI * 2 * counter / COUNTER_BUBBLE);
			y -= BUBBLEMODE_SPEED_Y;
			x += BUBBLEMODE_APLITUDE_X * Math.cos(2 * Math.PI * 3 * counter / COUNTER_BUBBLE);
			initStarsParticle(x, y);
		}
		else{
			scale.x = 1;
			scale.y = 1;
			setModeExplosion();		
		}
	}

	public function doActionCurve():Void
	{
		if(counter-- >0)
		{
			var lPoint:Point = BezierCurve.calculCurve(originPoint, bezierA, bezierB, finalDestination, (1 - counter / COUNTER_CURVE),true);
			x = lPoint.x;
			y = lPoint.y;
			initStarsParticle(x, y);
			
		}
		else
		{
			if(!SoundManager.getSound("gold").playing()) SoundManager.getSound("gold").play();
			RessourcesEffectManager.getInstance().OnEffectEnd();
		
			
			dispose();
			

		}
	}

	public function doActionExplosion():Void
	{
		var listRessourceLenght = listRessources.length;
		var lElement:RessourceEffect;
		var i:Int;
		if(counter-- > COUNTER_EXPLOSION/3)
		{
			for (i in 0...listRessourceLenght) 
			{
				lElement = listRessources[i];
				lElement.x = lElement.originPoint.x + Math.sin(Math.PI * 2 * counter / COUNTER_EXPLOSION)*RADIUS_EXPLOSION * Math.cos(Math.PI*2 * counter/COUNTER_EXPLOSION*2+2*Math.PI*i/listRessourceLenght);
				lElement.y = lElement.originPoint.y + Math.sin(Math.PI * 2 * counter / COUNTER_EXPLOSION)*RADIUS_EXPLOSION * Math.sin(Math.PI*2 * counter/COUNTER_EXPLOSION*2+2*Math.PI*i/listRessourceLenght);
			
				initStarsParticle(lElement.x, lElement.y);
			}
		}
		else
		{	
			counter--;
			for (j in 0...listRessourceLenght) 
			{
				i = listRessourceLenght - 1 - j;
				lElement = listRessources[i];
				lElement.x = lElement.originPoint.x + RADIUS_EXPLOSION * Math.cos(Math.PI*2 * counter/COUNTER_EXPLOSION*2+2*Math.PI*i/listRessourceLenght);
				lElement.y = lElement.originPoint.y + RADIUS_EXPLOSION * Math.sin(Math.PI*2 * counter/COUNTER_EXPLOSION*2+2*Math.PI*i/listRessourceLenght);
				lElement.dispertionCounter--;
				if (lElement.dispertionCounter <= 0)
				{
					lElement.setModeCurve();
					listRessources.splice(i, 1);
				}
				

			}

			if (listRessourceLenght == 0)
			{
				dispose();
			}
		}

		
	}
	
	public function doActionDispertion():Void
	{
		if(counter-- >0)
		{				
			x += directionDispersion.x * (counter/COUNTER_DISPERSION);
			y += directionDispersion.y * (counter / COUNTER_DISPERSION);
			initStarsParticle(x, y);
			
		}
		else{
			
			nextAction();	
		}
		
		
	}
	
	
	
}