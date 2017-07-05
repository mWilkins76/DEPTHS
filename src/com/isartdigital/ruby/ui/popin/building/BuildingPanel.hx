package com.isartdigital.ruby.ui.popin.building;

import com.isartdigital.utils.save.BuildingTypes.BuildingType;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;

/**
 * ...
 * @author Jordan Dachicourt
 */
class BuildingPanel
{
	
	private static inline var BUILDING_NAME:String = "BuildingMenutxt_BatimentName";
	private static inline var BUILD_TIME:String = "txt_buildTimeDisplay";
	private static inline var SC_PRICE = "txt_SCPrice";
	private static inline var HC_PRICE = "txt_HCPrice";
	private static inline var DARK_MATTER_PRICE:String = "txtMNPrice";
	private static inline var ENERGY:String = "txt_energyBuildingDisplay";
	private static inline var DESCRIPTION:String = "txt_descriptionBuilding";
	
	private var mainContainer:SmartComponent;
	private var buildingName:TextSprite;
	private var buildTime:TextSprite;
	private var scPrice:TextSprite;
	private var hcPrice:TextSprite;
	private var dmPrice:TextSprite;
	private var energy:TextSprite;
	private var description:TextSprite;
	
	public function new() {

	}
	
	public function init(pInfoContainer:SmartComponent) {
		mainContainer = pInfoContainer;
		buildingName = getTextSprite(BUILDING_NAME);
		
		buildTime = getTextSprite(BUILD_TIME);
		
		scPrice = getTextSprite(SC_PRICE);
		
		hcPrice = getTextSprite(HC_PRICE);
		
		dmPrice = getTextSprite(DARK_MATTER_PRICE);
		
		description = getTextSprite(DESCRIPTION);
		
		energy = getTextSprite(ENERGY);
		
		reset();
	}
	
	private function getTextSprite(pName:String):TextSprite {
		return cast(mainContainer.getChildByName(pName), TextSprite);
	}
	
	public function reset() {
		
		mainContainer.visible = false;
		buildingName.text = "";
		buildTime.text = "";
		scPrice.text = "";
		hcPrice.text = "";
		dmPrice.text = "";
		description.text = "";
		energy.text = "";
		
	}
	
	public function setInfo(pBuildingType:BuildingType) {
		
		mainContainer.visible = true;
	
		var h:Int = pBuildingType.buildingTime.getHours()-1;
		var m:Int = pBuildingType.buildingTime.getMinutes();
		var s:Int = pBuildingType.buildingTime.getSeconds();
		buildingName.text = LocalizationByType.getInstance().translateFromType(pBuildingType.buildingName);
		buildTime.text = "" + ((h>0)?h+" H ":"") + ((m>0)?m+" m ":"") + ((s>0)?s+" s":"");
		scPrice.text = "" + pBuildingType.softCurrencyCost;
		hcPrice.text = "" + pBuildingType.hardCurrencyCost;
		dmPrice.text = "" + pBuildingType.ressourcesCost;
		description.text = "" + LocalizationByType.getInstance().translateFromType(pBuildingType.description);
		energy.text = "" + pBuildingType.energyCost;
		
	}
	
}