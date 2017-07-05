package com.isartdigital.ruby.game.controller;
import com.isartdigital.ruby.game.controller.Controller;
import com.isartdigital.ruby.game.world.Region;
import com.isartdigital.ruby.game.world.RegionContainer;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.Camera;
import com.isartdigital.ruby.utils.Focus;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.iso.IsoManager;
import com.isartdigital.utils.ui.Button;
import js.Browser;
import js.html.MouseEvent;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.interaction.InteractionManager;
 
   
/**
 * ...
 * @author Jordan Dachicourt
 */
class MouseController extends Controller
{
    
	
	
    /**
     * instance unique de la classe MouseController
     */
    private static var instance: MouseController;
   
    /**
     * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
     * @return instance unique
     */
    public static function getInstance (): MouseController {
        if (instance == null) instance = new MouseController();
        return instance;
    }
   
    /**
     * constructeur privé pour éviter qu'une instance soit créée directement
     */
    private function new()
    {
		super();
       
    }
	
	/**
	 * Initialise les écouteurs
	 */
	override public function init():Void 
	{
		super.init();
		
		
		gameContainer.on(MouseEventType.MOUSE_DOWN, onTap);
		alienContainer.on(MouseEventType.MOUSE_DOWN, onTap);
		gameContainer.on(MouseEventType.MOUSE_UP, onUntap);
		alienContainer.on(MouseEventType.MOUSE_UP, onUntap);
        gameContainer.on(MouseEventType.MOUSE_MOVE, onMove);
		gameContainer.on(MouseEventType.MOUSE_OUT, onOut);
		gameContainer.on(MouseEventType.MOUSE_OVER, onOver);
		gameContainer.on(MouseEventType.MOUSE_DOWN, onDown);
		gameContainer.on(MouseEventType.MOUSE_UP, onUp);
		
	}    
	
    /**
     * détruit l'instance unique et met sa référence interne à null
     */
    public function destroy (): Void {
        instance = null;
		
        gameContainer.off(MouseEventType.CLICK, onTap);
        gameContainer.off(MouseEventType.MOUSE_UP, onUntap);
        gameContainer.off(MouseEventType.MOUSE_MOVE, onMove);
		gameContainer.off(MouseEventType.MOUSE_OUT, onOut);
		gameContainer.off(MouseEventType.MOUSE_DOWN, onDown);
		gameContainer.off(MouseEventType.MOUSE_UP, onUp);
    }
	
   
 
}