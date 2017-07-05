package com.isartdigital.ruby.game.controller;
import com.isartdigital.ruby.game.controller.Controller;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.iso.IsoManager;
import com.isartdigital.utils.ui.Button;
import js.html.MouseEvent;
import js.html.TouchEvent;
import js.html.UIEvent;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.interaction.InteractionManager;
 
   
/**
 * ...
 * @author Julien Fournier && Jordan Dachicourt
 */
class TouchController extends Controller
{
    /**
     * instance unique de la classe TouchController
     */
    private static var instance: TouchController;
   
    /**
     * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
     * @return instance unique
     */
    public static function getInstance (): TouchController {
        if (instance == null) instance = new TouchController();
        return instance;
    }
   
    /**
     * constructeur privé pour éviter qu'une instance soit créée directement
     */
    private function new()
    {
       super();
    }
	
	
	override public function init():Void 
	{
		super.init();
		
		gameContainer.on(TouchEventType.TAP, onTap);
		alienContainer.on(TouchEventType.TAP, onTap);
        gameContainer.on(TouchEventType.TOUCH_START, onDown);
        gameContainer.on(TouchEventType.TOUCH_END, onUp);
		gameContainer.on(TouchEventType.TOUCH_END_OUTSIDE, onOut);
        gameContainer.on(TouchEventType.TOUCH_MOVE, onMove);

		
	}
   
	/**
	 * Initialise les écouteurs
	 */
	override function onUp():Void 
	{
		super.onUp();
		Controller.isTap = false;
	}
      
    /**
     * détruit l'instance unique et met sa référence interne à null
     */
    public function destroy (): Void {
        instance = null;
		
		gameContainer.off(TouchEventType.TAP, onTap);
        gameContainer.off(TouchEventType.TOUCH_START, onDown);
        gameContainer.off(TouchEventType.TOUCH_END, onUp);
		gameContainer.off(TouchEventType.TOUCH_END_OUTSIDE, onOut);
        gameContainer.off(TouchEventType.TOUCH_MOVE, onMove);
    }
   
 
}