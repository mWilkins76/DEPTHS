package com.isartdigital.ruby.game.sprites.elements.alienbuilding;
import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.game.specialFeature.managers.SpecialFeatureAliens;
import com.isartdigital.ruby.game.sprites.elements.aliens.Alien;
import com.isartdigital.ruby.game.sprites.elements.aliens.AlienElement;
import com.isartdigital.ruby.game.sprites.elements.aliens.AlienEsthetique;
import com.isartdigital.ruby.game.sprites.elements.aliens.alienspaddockable.AlienBuffer;
import com.isartdigital.ruby.game.sprites.elements.aliens.alienspaddockable.AlienProducer;
import com.isartdigital.ruby.utils.TimeManager;
import com.isartdigital.utils.game.clipping.IClippable.Element;
import com.isartdigital.utils.game.pooling.PoolObject;
import com.isartdigital.utils.save.DataBaseAction;
import com.isartdigital.utils.save.DataManager;

/**
 * ...
 * @author Julien Fournier
 */

typedef AlienCarac =
{
	var alien:Alien;
	var dateStartCreation:Date;
	var dateEndCreation:Date;
}
class AlienIncubator extends Building
{

	//public var currentAlienCreating(default, set):Alien;

	public var alienOneCreating:Bool;
	public var alienTwoCreating:Bool;

	public var alienSlot1:AlienElement;
	public var alienSlot2:AlienElement;

	private var alienSlot1Time:Date;
	private var alienSlot2Time:Date;

	public function new(pAsset:String=null)
	{
		super(pAsset);

		buildingName = "Incubator";
		description = "Permet de créer un Xénos.";
		localWidth = 6;
		localHeight = 3;
		maxLevel = 2;
		canReceiveAliens = true;
		sellingCost = 3125;
	}

	override public function init(?pElem:Element=null):Void
	{
		super.init(pElem);
	}

	override public function start():Void
	{
		super.start();
		if ((alienSlot1 != null && alienSlot1.mode == "Constructing") || (alienSlot2 != null && alienSlot2.mode == "Constructing")) doAction = doActionCollecting;
	}

	override function setModeCollect():Void
	{
		super.setModeCollect();
	}

	override function doActionCollecting():Void
	{
		//super.doActionCollecting();
		if (alienSlot1 == null && alienSlot2 == null)
		{
			setModeNormal();
			return;
		}
		
		if (alienSlot1 != null && alienSlot1Time == null && alienSlot1.endTime != null) alienSlot1Time = Date.fromString(alienSlot1.endTime);
		if (alienSlot2 != null && alienSlot2Time == null && alienSlot2.endTime != null) alienSlot2Time = Date.fromString(alienSlot2.endTime);

		if (alienSlot1 != null && alienSlot1Time != null)
		{
			if (TimeManager.getInstance().getTimeInSecondsToFinishBuilding(alienSlot1Time) >= 0)
			{
				Alien.alienElementList[Alien.alienElementList.indexOf(alienSlot1)].mode = "Waiting";
				alienSlot1.mode = "Waiting";
				DataBaseAction.getInstance().releaseAlienMode(alienSlot1.idAlien, alienSlot1.mode);
				alienSlot1 = null;
			}

			
		}

		if (alienSlot2 != null && alienSlot2Time != null)
		{
			if (TimeManager.getInstance().getTimeInSecondsToFinishBuilding(alienSlot2Time) >= 0)
			{
				Alien.alienElementList[Alien.alienElementList.indexOf(alienSlot2)].mode = "Waiting";
				alienSlot2 = null;
			}

			
		}

	}

	public function addAlien(pAlien:Dynamic, pSlotAlien:Int, pCategory:String ):Void
	{
		
		
		var lAlien:Dynamic = Reflect.getProperty(this, "alienSlot" + pSlotAlien);

		var alienID:String = pAlien.name+Date.now().getTime();

		var lAlienElem:AlienElement =
		{
			idAlien:alienID,
			idBuilding:this.elem.instanceID,
			mode:"Constructing",
			name:pAlien.name,
			type:pAlien.type,
			nomPropre:"",
			stamina:Std.int(pAlien.stamina),
			//level:Std.int(pAlien.level),
			level:1,
			startTime:null,
			endTime:null,
			carac:Alien.getAlienType("name", DataManager.getInstance().getAlienArray(pAlien.type)),
			idPlayer:Player.getInstance().id
		}
		Alien.alienElementList.push(lAlienElem);
		DataBaseAction.getInstance().addAlien(alienID, this.elem.instanceID, pAlien.type, pAlien.name, "", pAlien.stamina, pAlien.time);
		Reflect.setProperty(this, "alienSlot" + pSlotAlien, lAlienElem); /************ !!!!!a push egalement dans le codex!!!!! *****************/
		doAction = doActionCollecting;
		//TO DO : ajouter alien dans les slots, demarrer le mode creation, ajouter les aliens dans les slots au chargement.
	}

	private function setTime(pAlienSlot:AlienElement, pAlienSlotTime:Date):Void
	{
		pAlienSlotTime = Date.fromString(pAlienSlot.endTime);
		
	}

}