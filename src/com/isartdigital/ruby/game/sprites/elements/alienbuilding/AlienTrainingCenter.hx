package com.isartdigital.ruby.game.sprites.elements.alienbuilding;
import com.isartdigital.ruby.game.sprites.elements.aliens.AlienElement;
import com.isartdigital.ruby.game.world.MapInteractor;
import com.isartdigital.ruby.ui.UIManager;
import com.isartdigital.ruby.ui.popin.upgradeCenter.UpgradeCenter;
import com.isartdigital.utils.game.clipping.IClippable.Element;
import com.isartdigital.utils.save.DataBaseAction;
import com.isartdigital.utils.sounds.SoundManager;

/**
 * ...
 * @author Julien Fournier
 */
class AlienTrainingCenter extends Building
{

	public var slot1Bought:Bool;
	public var slot2Bought:Bool;
	
	public var aliens:Array<AlienElement>;
	public var alien:AlienElement;
	
	public function new(pAsset:String=null) 
	{
		super(pAsset);
		buildingName = "Training Center";
		description = "Permet de faire evoluer les xénos.";
		localWidth = 3;
		localHeight = 3;
		sellingCost = 6250;
		canReceiveAliens = true;
		maxLevel = 3;
		aliens = [];
		//setTimeToBuild : secondes/minutes/heures/jours
		//setTimeToBuild(0, 0, 1, 0);
	}
	
	override public function upgrade():Void 
	{
		super.upgrade();
	}
	
	override public function init(?pElem:Element=null):Void 
	{
		super.init(pElem);

		if (level == 2) slot1Bought = true;
		if (level == 3) slot2Bought = true;
		
	}
	
	public function addAlien(pAlienElem:AlienElement):Void {
		
		
		pAlienElem.idBuilding = elem.instanceID;
		alien = pAlienElem;
		DataBaseAction.getInstance().changeAlienIdBuilding(pAlienElem.idAlien, pAlienElem.idBuilding);
		MapInteractor.getInstance().stopAlienMode();
		SoundManager.getSound("soundPlayerPutXenos").play();
		UpgradeCenter.getInstance().initializationCurrentBuildingTrainingCenter(this);
		UpgradeCenter.getInstance().setAlien();
		UIManager.getInstance().openPopin(UpgradeCenter.getInstance());
		
		
	}
	
	
}