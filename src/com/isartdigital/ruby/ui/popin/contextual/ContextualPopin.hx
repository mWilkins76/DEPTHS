package com.isartdigital.ruby.ui.popin.contextual;
import com.isartdigital.ruby.game.controller.Controller;
import com.isartdigital.ruby.game.sprites.elements.Building;
import com.isartdigital.ruby.game.sprites.elements.GameElement;
import com.isartdigital.ruby.game.world.Background;
import com.isartdigital.ruby.game.world.Region;
import com.isartdigital.utils.game.GameObject;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.iso.IsoManager;
import js.Lib;
import pixi.core.math.Point;

/**
 * ...
 * @author Jordan Dachicourt
 */
class ContextualPopin extends SmartPopinRegister
{
	

	@:isVar public var target(get, set):GameElement;
	
	function get_target() {
		return target;
	}

	function set_target(pTarget) {
		target = pTarget;
		initPositionCenterTarget();
		return target;
	}
	private var positionCenterTarget:Point;
	
	public function new(pID:String=null) 
	{
		super(pID);
	}

	override public function open():Void 
	{
		super.open();
		GameStage.getInstance().getInfoBulleContainer().addChild(this);
		
	}
	

	private function initPositionCenterTarget(){
		var lModelPos:Point = new Point(0,0);
		if (!Std.is(target, Background)) {
			lModelPos = IsoManager.isoViewToModel(new Point(target.globalPosition.x, target.globalPosition.y));
			lModelPos.x = lModelPos.x + (Controller.getInstance().getPosRegion().x);
			lModelPos.y = lModelPos.y + (Controller.getInstance().getPosRegion().y);
		}
		else {
			
			lModelPos.x += (target.currentRegionCoor.x * Region.WIDTH);
			lModelPos.y += (target.currentRegionCoor.y * Region.HEIGHT);
		}
		lModelPos.x += Math.round(target.localWidth / 2);
		lModelPos.y += Math.round(target.localHeight / 2);
		positionCenterTarget = IsoManager.modelToIsoView(lModelPos);
		position = positionCenterTarget;
	}
	
	override public function close():Void 
	{
		removeAllListeners();
		if(parent != null) parent.removeChild(this);
		super.close();
	}
	
}