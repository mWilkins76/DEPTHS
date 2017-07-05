package com.isartdigital.ruby.game.sprites.elements.aliens.alienspaddockable;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienPaddock;
import com.isartdigital.ruby.game.sprites.elements.aliens.AlienElement;
import com.isartdigital.ruby.utils.TimeManager;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.BoxType;
import com.isartdigital.utils.game.clipping.IClippable.Element;
import com.isartdigital.utils.game.factory.FlumpMovieAnimFactory;
import com.isartdigital.utils.game.iso.IZSortable;
import pixi.core.math.Point;
import pixi.flump.Movie;
import sys.db.Types.STimeStamp;

/**
 * ...
 * @author Adrien Bourdon
 */
class AlienPaddockable extends Alien implements IZSortable
{
	public var aElem : AlienElement;
	
	public var colMin:Int;
	
	public var colMax:Int;
	
	public var rowMin:Int;
	
	public var rowMax:Int;
	
	public var behind:Array<IZSortable>;
	
	public var inFront:Array<IZSortable>;
	
	public var ownPaddock:AlienPaddock;
	
	public function new(?pAsset:String) 
	{
		super(pAsset);
		
	}
	
	public function setPosition(pPos:Point):Void {
	
		colMin = colMax = cast(pPos.x);
		rowMin = rowMax = cast(pPos.y);
	}
	
	public function setPaddock(pPaddock:AlienPaddock):Void {
	
		ownPaddock = pPaddock;
		on(MouseEventType.CLICK, onClickk);
	}
	
	private function onClickk():Void {
	
		
	}
	
	
	public function setElem(pElem:AlienElement):Void {
	
		aElem = pElem;
		assetName = aElem.name;
		level = aElem.level;
	}
	
	override public function start():Void 
	{
		boxType = BoxType.NONE;
		factory = new FlumpMovieAnimFactory();
		
		changeAsset("Harvest");

	}
	
	public function changeAsset(pState:String):Void {
	
		setState(pState+"_Lvl" + level);
	}
	//gestion des etats graphiques
	
	
	private function loopanim():Void {
	
		if (cast(anim, Movie).currentFrame >= cast(anim, Movie).totalFrames -2) changeAsset("Harvest");
	}
}

