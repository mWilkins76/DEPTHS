package com.isartdigital.ruby.game.sprites.elements;

import com.isartdigital.ruby.game.specialFeature.managers.SFGameManager;
import com.isartdigital.ruby.game.sprites.FlumpStateGraphic;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienTrainingCenter;
import com.isartdigital.ruby.game.sprites.elements.cosmeticbuilding.cosmetictype.BuildingCosmeticCapsule1;
import com.isartdigital.ruby.game.sprites.elements.cosmeticbuilding.cosmetictype.BuildingCosmeticCapsule2;
import com.isartdigital.ruby.game.sprites.elements.cosmeticbuilding.cosmetictype.BuildingCosmeticCapsule3;
import com.isartdigital.ruby.game.sprites.elements.cosmeticbuilding.cosmetictype.BuildingCosmeticPlant1;
import com.isartdigital.ruby.game.sprites.elements.cosmeticbuilding.cosmetictype.BuildingCosmeticPlant2;
import com.isartdigital.ruby.game.sprites.elements.cosmeticbuilding.cosmetictype.BuildingCosmeticPlant3;
import com.isartdigital.ruby.game.world.Layer;
import com.isartdigital.ruby.utils.ParticleManager;
import com.isartdigital.utils.Config;
import com.isartdigital.ruby.game.world.Region;
import com.isartdigital.ruby.game.world.World;
import com.isartdigital.ruby.ui.UIManager;
import com.isartdigital.ruby.ui.popin.Destruction;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.game.BoxType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.clipping.IClippable.Element;
import com.isartdigital.utils.game.factory.FlumpMovieAnimFactory;
import com.isartdigital.utils.game.iso.IZSortable;
import com.isartdigital.utils.game.pooling.PoolObject;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.save.DataBaseAction;
import com.isartdigital.utils.save.DataManager;
import com.isartdigital.utils.sounds.SoundManager;
import haxe.Json;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.filters.color.ColorMatrixFilter;

import js.Lib;

/**
 * ...
 * @author Michael Wilkins / Julien Fournier
 */

 	/**
	 * month: 0 to 11 // day: 1 to 31 // hour: 0 to 23 // min: 0 to 59 // sec: 0 to 59
	 */
	typedef BuildingTime = {
		var seconds:Int;
		var minutes:Int;
		var hours:Int;
		var days:Int;
	}
	
	
class GameElement extends PoolObject implements IZSortable
{	
	public static var JSON_CONFIG:Dynamic = GameLoader.getContent("caracBuilding.json");
	public var colMin:Int;
	public var colMax:Int;
	
	public var currentState :String;
	
	public var rowMin:Int;
	public var rowMax:Int;
	
	public var behind:Array<IZSortable>;
	public var inFront:Array<IZSortable>;
	
	public var localWidth:Int;
	public var localHeight:Int;
	
	public var margin:Int = 0;
	
	public var className:String;
	
	public var timeToBuild:BuildingTime;
	public var timeToUpgrade:BuildingTime;
	public var dateEndBuilding:Date;
	public var dateStartBuilding:Date;

	public var level:Int = 1;
	public var maxLevel:Int = 1;
	
	private var hoverFilter:ColorMatrixFilter = new ColorMatrixFilter();
	private var redFilter:ColorMatrixFilter = new ColorMatrixFilter();
	private var greyFilter:ColorMatrixFilter = new ColorMatrixFilter();
	
	public var SPAWNING_STATE(default, never):String = "Spawning";
	public var CONSTRUCTING_STATE(default, never):String = "Constructing";
	public var WAITING_STATE(default, never):String = "Wait";
	public var COLLECTING_STATE(default,never):String = "Recolting";
	public var UPGRADING_STATE(default,never):String = "Upgrading";
	
	public var currentRegionCoor:Point;
	
	public var globalPosition:Point;
	public var contextualOpened:Bool = false;
	
	
	
	public function new(pAsset:String=null) 
	{
		super(pAsset);
		className = Type.getClassName(Type.getClass(this)).split(".").pop();
		name = className;
		interactive = true;
		hoverFilter.matrix = [1.3,0,0,0,0,0,1.3,0,0,0,0,0,1.3,0,0,0,0,0,1,0];
		greyFilter.matrix = [0.309,0.609,0.082,0,0,0.309,0.609,0.082,0,0,0.309,0.609,0.082,0,0,0,0,0,1,0];
		redFilter.matrix = [1,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
	}
	
	public function changeAsset(pState:String, ?pAutoPlay:Bool = true):Void {
		
		if (pState == UPGRADING_STATE) pState = CONSTRUCTING_STATE;
		else if (pState == "WaitValidation") pState = WAITING_STATE;
		if (maxLevel == 1 || Std.is(this, AlienTrainingCenter) || Std.is(this, BuildingCosmeticCapsule1) 
		|| Std.is(this, BuildingCosmeticCapsule2) || Std.is(this, BuildingCosmeticCapsule3) || Std.is(this, BuildingCosmeticPlant1) 
		|| Std.is(this, BuildingCosmeticCapsule3) || Std.is(this, BuildingCosmeticPlant2) || Std.is(this, BuildingCosmeticCapsule3) || Std.is(this, BuildingCosmeticPlant3)) setState(pState, true, pAutoPlay);
		else setState(pState+"_Lvl" + level, true, pAutoPlay);
	}
	
	override public function init(?pElem:Element=null):Void {
		//Lib.debug();

		super.init(pElem);
		
		initColAndRow();
		
		dateEndBuilding = pElem.dateEndBuilding;
		dateStartBuilding = pElem.dateStartBuilding;
		currentRegionCoor = new Point(pElem.regionX, pElem.regionY);
	}
	
	private function initColAndRow():Void
	{
		colMin = elem.x;
		rowMin = elem.y;
		
		colMax = colMin + localWidth - 1;
		rowMax = rowMin + localHeight - 1;
	}
	
	public function changePosition(pX:Int, pY:Int):Void 
	{
		colMin = pX;
		rowMin = pY;
	}
	
	
	private function setTimeToBuild(pSec:Int, pMin:Int, pHour:Int, pDay:Int):Void
	{
		timeToBuild = 
		{		
			seconds:pSec,
			minutes:pMin,
			hours:pHour,
			days:pDay	
		};
	}
	
	public function setModeDestroy():Void {
		
		var lParticle2:Container = ParticleManager.getInstance().createParticle("destroy", ["smoke4","sparks3"], 5000);
		lParticle2.position = this.position.clone();
		
		var lParticle:Container = ParticleManager.getInstance().createParticle("dig", ["bloc1","bloc2","bloc3","bloc4","smoke4"], 5000);
		lParticle.position = this.position.clone();
		
		GameStage.getInstance().getGameContainer().addChild(lParticle);
		GameStage.getInstance().getGameContainer().addChild(lParticle2);	
		
		DataBaseAction.getInstance().destroyBuilding(elem.instanceID);
		SoundManager.getSound("soundPlayerDestroyBuilding").play();
		World.getInstance().getRegion(cast(currentRegionCoor.x, Int), cast(currentRegionCoor.y, Int)).layers[1].remove(this);
		dispose(); // à bouger à la fin de l'anim destroy
		PoolObject.elementList.remove(instanceID);
		DataManager.getInstance().save(PoolObject.elementList);
		doAction = doActionDestroy;
	}
	
	public function hasSameCoordonatesAs(pBuilding:GameElement):Bool
	{
		// if same region and same colmin/rowmin return true
		if (currentRegionCoor.x == pBuilding.currentRegionCoor.x && currentRegionCoor.y == pBuilding.currentRegionCoor.y && colMin == pBuilding.colMin && rowMin == pBuilding.rowMin) return true;
		else return false;
	}
	
	
	//Filtre
	public function applyHoverFilter():Void 
	{	
		if (filters == null) {
			if (!contextualOpened) {
			
				SoundManager.getSound("soundPlayerClic").play();
				filters = [hoverFilter];
			}
			
		}
	}
	
	public function removeHoverFilter():Void 
	{	
		if (filters != null) filters = null;
	}
	
	public function applyGreyFilter():Void 
	{	
		if (filters == null) filters = [greyFilter];
	}
	
	public function removeGreyFilter():Void 
	{	
		if (filters != null) filters = null;
	}
	public function applyRedFilter():Void 
	{	
		if (filters == null) filters = [redFilter];
	}
	
	public function removeRedFilter():Void 
	{	
		if (filters != null) filters = null;
	}
	
	
	public function doActionDestroy():Void {
		
	}

	
	
	
	
}