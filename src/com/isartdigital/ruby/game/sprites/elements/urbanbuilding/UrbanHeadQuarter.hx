package com.isartdigital.ruby.game.sprites.elements.urbanbuilding;
import com.isartdigital.ruby.game.world.Region;
import com.isartdigital.ruby.game.world.World;
import com.isartdigital.ruby.ui.ftue.FTUEManager;
import com.isartdigital.utils.game.clipping.IClippable.Element;
import com.isartdigital.utils.sounds.SoundManager;
import pixi.flump.Movie;

/**
 * ...
 * @author Julien Fournier
 */
class UrbanHeadQuarter extends Building
{

	public function new(pAsset:String=null) 
	{
		super(pAsset);
		buildingName = "Head Quarter";
		description = "Donne les informations sur votre planète. Les évolutions des autres batiments dépendent du niveau de celui-ci.";
		localWidth = 6;
		localHeight = 6;
		maxLevel = 4;
		level = 1;
		Building.HQinstance = this;
		sellingCost = 0;
		//setTimeToBuild : secondes/minutes/heures/jours
		//setTimeToBuild(1, 0, 0, 0);
	}
	
	override public function init(?pElem:Element=null):Void 
	{
		super.init(pElem);
		

	}
	
	override public function start():Void 
	{
		super.start();
		if (World.getInstance().getRegion(elem.regionX, elem.regionY).powerStationsInRegion.length == 0) changeAsset(CONSTRUCTING_STATE);
	}
	
	public function turnOn():Void {
	
		changeAsset(WAITING_STATE);
		SoundManager.getSound("soundPlayerStartCreateBuilding").play();
	}
	
}