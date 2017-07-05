package com.isartdigital.ruby.game.controller;
import com.isartdigital.ruby.game.world.Region;
import com.isartdigital.ruby.game.world.World;
import com.isartdigital.ruby.ui.ftue.FTUEPopin;
import com.isartdigital.ruby.ui.popin.ConfirmationPose;
import com.isartdigital.ruby.ui.popin.building.BuildingMenu;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.game.Camera;
import com.isartdigital.ruby.utils.Focus;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.iso.IsoManager;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.system.DeviceCapabilities;
import js.Browser;
import js.html.Event;
import js.html.TouchEvent;
import js.html.UIEvent;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.interaction.InteractionManager;

/**
 * ...
 * @author Julien Fournier && Jordan Dachicourt
 */
class Controller
{
	public static var isDown: Bool;
	public static var isIn:Bool;
	public static var isMoving: Bool;
	public static var isTap: Bool;
	public static var isUp: Bool;
	public static var isClicked: Bool;
	
	private var oldPos:Point;
	private var clamp:Float = 50;
	
	private var speed:Float = 0.6;
	
	private static var clicCounter:Int = 0;
	private var maxClic:Int = 20;
	public static var  shortClic:Bool;
	
	

	
	public var deltaX:Float = 0;
	public var deltaY:Float = 0;
	public var gameContainer:Container = GameStage.getInstance().getGameContainer();
	public var alienContainer:Container = GameStage.getInstance().getAlienContainer();

	/**
	 * instance unique de la classe TouchController
	 */
	private static var instance: Controller;

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Controller
	{
		if (instance == null) instance = new Controller();
		return instance;
	}

	private function new()
	{

	}

	/**
	 * Initialise le Controller
	 */
	public function init():Void
	{

		gameContainer.interactive = true;
		gameContainer.buttonMode = true;
		gameContainer.defaultCursor = "url(assets/Curseur.png), auto";
		
		isDown = false;
		isIn = true;
	}

	

	public function detectClicLength():Void {
		
		if (isTap) clicCounter++;
		if (BuildingMenu.getInstance().isOpened) clicCounter = maxClic;
		
		if (shortClic) {
			shortClic = false;
		}
	}
	
	/**
	 * Les controlles sont avant tout pensé sur une logique mobile et est adapté pc
	 * c'est pourquoi les nom Tap on été gardé pour fonctions
	 */

	/**
	 * Callback
	 */

	private function onTap():Void
	{
		isTap = true;
		isUp = false;
		clicCounter = 0;
		shortClic = false;
		
	}

	private function onUntap():Void
	{

		
		if (clicCounter < maxClic) shortClic = true;
		
		
		
		isUp = true;
		isTap = false;
		
	}

	private function onDown(pEvent:TouchEvent):Void
	{
		isDown = true;
		oldPos = getPosFrom(GameStage.getInstance(),pEvent);
	}

	private function onOut():Void
	{
		isDown = false;
		isIn = false;
	}
	
	private function onOver():Void
	{
		isIn = true;
	}

	private function onUp():Void
	{
		isDown = false;
	}
	/**
	 * deplace le focus si(onDown)
	 */
	private function onMove(pEvent:TouchEvent):Void
	{
		if (isDown)
		{
			isMoving = true;
			var currentPos = getPosFrom(GameStage.getInstance(), pEvent);

			deltaX = (oldPos.x - currentPos.x)*speed;
			deltaY = (oldPos.y - currentPos.y)*speed;

			var newX:Float =  Focus.getInstance().x - ((Math.abs(deltaX) > clamp) ? clamp *  (Math.abs(deltaX)/deltaX): deltaX);
			var newY:Float =  Focus.getInstance().y - ((Math.abs(deltaY) > clamp) ? clamp * (Math.abs(deltaY) / deltaY) : deltaY);

			//important ici de mettre une nouvelle référence de Point, pour eviter que le oldPos et position de Focus pointe sur la même référence
			
			Focus.getInstance().toMove(new Point(deltaX, deltaY));

			oldPos = currentPos;
		}
		else {
			deltaX = 0;
			deltaY = 0;
			isMoving = false;
		}
	}

	
	
	/**
	 * Donne la region en dessous de la souris
	 * @return la region
	 */
	public function getMouseRegion():Region
	{

		return World.getInstance().getRegion(cast(getPosRegion().x, Int), cast(getPosRegion().y, Int));
	}

	/**
	 * Donne la position de la souris relative à un container
	 * @param	pContainer le container parent
	 * @return la position relative
	 */
	public function getPosFrom(pContainer:Container, ?pEvent:TouchEvent = null):Point
	{
		//if (pEvent == null) return;
		/*if (DeviceCapabilities.system != DeviceCapabilities.SYSTEM_DESKTOP)
		{
			//var pTouchEvent = cast(pEvent, TouchEvent);
			return new Point(pEvent.targetTouches[pEvent.targetTouches.length - 1].clientX, pEvent.targetTouches[pEvent.targetTouches.length - 1].clientY);
		}
		else */
		
		return new Point(cast(Main.getInstance().renderer.plugins.interaction, InteractionManager).mouse.getLocalPosition(pContainer).x, cast(Main.getInstance().renderer.plugins.interaction, InteractionManager).mouse.getLocalPosition(pContainer).y);
	}

	/**
	 * Position relative à un container en Iso
	 * @param	pContainer
	 * @return
	 */
	public function getIsoPosFrom(pContainer:Container):Point
	{
		return IsoManager.modelToIsoView(getPosFrom(pContainer));
	}

	/**
	 * Donne les coordonné region actuelle
	 * @return
	 */
	public function getPosRegion():Point
	{
		var lPoint:Point = IsoManager.localToModel(getPosFrom(gameContainer));

		lPoint.x /= Region.WIDTH;
		lPoint.y /= Region.HEIGHT;
		lPoint.x = Math.floor(lPoint.x);
		lPoint.y = Math.floor(lPoint.y);
		return lPoint;
	}

	public function doAction() {
		
		
		
	}
}