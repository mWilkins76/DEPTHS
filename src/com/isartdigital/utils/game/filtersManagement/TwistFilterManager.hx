package com.isartdigital.utils.game.filtersManagement;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.renderers.webgl.filters.AbstractFilter;
import pixi.filters.twist.TwistFilter;

	
/**
 * ...
 * @author Jordan Dachicourt
 */
class TwistFilterManager 
{
	
	/**
	 * instance unique de la classe TwistFilterManager
	 */
	private static var instance: TwistFilterManager;
	
	private var gameContainer: Container;
	private var twists:Array<AbstractFilter>;
	private var timer:Float;
	private var elapseTime:Float;
	private var offsetLimit:Float;
	private var direction:Point;
	private var start:Point;
	private var speed:Float;
	private var maxTwist:Float;
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): TwistFilterManager {
		if (instance == null) instance = new TwistFilterManager();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		
	}
	
	public function init(pGameContainer:Container, pTimer:Float) {
		gameContainer = pGameContainer;
		timer = pTimer;
		elapseTime = 0;
		twists = new Array<AbstractFilter>();
		direction = new Point(0.5, 0.5);
		start = new Point( -1, -1);
		offsetLimit = 1.5;
		speed = 0.01;
		maxTwist = 10;
	}
	
	public function addTwist() {
		if (gameContainer == null || twists.length > maxTwist) return;

		var lTwist:TwistFilter = new TwistFilter();
		lTwist.angle = 0.03;
		lTwist.radius = 0.5;
		lTwist.padding = 0;
		lTwist.offset.x = start.x;
		lTwist.offset.y = start.y;
		twists.push(lTwist);
		gameContainer.filters = twists;
	}
	
	public function doAction() {
			moveTwist();
			addTwistOnTick();
	}
	
	private function moveTwist() {
		
		if (gameContainer.filters == null) return;

		for (i in 0 ... gameContainer.filters.length) {
			
			var lTwist:TwistFilter = cast(gameContainer.filters[i], TwistFilter);
	
			lTwist.offset.x += direction.x * speed;
			lTwist.offset.y += direction.y * speed;
		
			if (lTwist.offset.x > offsetLimit || lTwist.offset.y > offsetLimit) {
				twists.remove(gameContainer.filters[i]);
			}
		}
	}
	
	public function addTwistOnTick() {
		elapseTime += 0.1;
		if (elapseTime >= timer) {
			addTwist();
			elapseTime = 0;	
		}
	}
	
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}