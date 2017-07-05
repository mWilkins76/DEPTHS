package com.isartdigital.ruby.game.sprites.elements.alienbuilding;

import com.isartdigital.ruby.game.sprites.elements.Building;
import com.isartdigital.ruby.game.sprites.elements.aliens.Alien;
import com.isartdigital.ruby.game.sprites.elements.aliens.AlienElement;
import com.isartdigital.utils.game.clipping.IClippable.Element;

/**
 * ...
 * @author Guillaume Zegoudia
 */
class AlienCryoCenter extends Building
{
	public var xenosStorage:Array<AlienElement> = [];
	
	private var storageLength:UInt = 15; // a modif après le playtest
	private var lengthSizeFactor:UInt = 2;
	public function new(?pAsset:String=null) 
	{
		super(pAsset);
		buildingName = "CryoCenter";
		description = "Stocke les xenos implaçables.";
		localWidth = 3;
		localHeight = 3;
		maxLevel = 4;
		canReceiveAliens = false;
		sellingCost = 4375;
	}
	
	override public function init(?pElem:Element = null):Void 
	{
		
		super.init(pElem);
		
		for (alien in Alien.alienElementList)
		{
			if (alien.idBuilding == elem.instanceID)
			{
				xenosStorage.push(alien);
			}
		}
	}
	
}