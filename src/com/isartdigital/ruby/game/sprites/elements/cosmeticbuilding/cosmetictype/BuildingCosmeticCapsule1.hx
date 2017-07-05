package com.isartdigital.ruby.game.sprites.elements.cosmeticbuilding.cosmetictype;

import com.isartdigital.ruby.game.sprites.elements.cosmeticbuilding.CosmeticBuilding;
import com.isartdigital.ruby.ui.LocalizationByType;
import com.isartdigital.utils.system.Localization;
import flump.library.Label;

/**
 * ...
 * @author Guillaume Zegoudia
 */
class BuildingCosmeticCapsule1 extends CosmeticBuilding
{

	public function new(pAsset:String=null) 
	{
		super(pAsset);
		description = Localization.getLabel(LocalizationByType.COSMETIC_CAPSULE1);
	}
	
}