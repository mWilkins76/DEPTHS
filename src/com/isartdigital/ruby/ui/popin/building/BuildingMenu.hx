package com.isartdigital.ruby.ui.popin.building;

import com.isartdigital.ruby.game.Spawner;
import com.isartdigital.ruby.game.controller.Controller;
import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.game.sprites.elements.ElementType;
import com.isartdigital.ruby.game.sprites.elements.GameElement;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienIncubator;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienPaddock;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienResearchCenter;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienTrainingCenter;
import com.isartdigital.ruby.game.sprites.elements.drillingbuilding.DrillingAutoOutPost;
import com.isartdigital.ruby.game.sprites.elements.drillingbuilding.DrillingCenter;
import com.isartdigital.ruby.game.sprites.elements.drillingbuilding.DrillingOutPost;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.UrbanAntenna;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.UrbanCommunication;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.UrbanHeadQuarter;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.UrbanPowerStation;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.UrbanTranslation;
import com.isartdigital.ruby.game.world.MapInteractor;
import com.isartdigital.ruby.ui.ftue.FTUEManager;
import com.isartdigital.ruby.ui.Slider;
import com.isartdigital.ruby.ui.popin.building.datas.BuildingMenuData;
import com.isartdigital.ruby.ui.items.switchItems.BuildingMenuSwitchItem;
import com.isartdigital.ruby.ui.items.switchItems.BuildingMenuSwitchTab;
import com.isartdigital.ruby.ui.popin.building.datas.BuildingMenuParams;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.system.DeviceCapabilities;
import com.isartdigital.utils.ui.SmartText;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.display.DisplayObject;
import pixi.core.graphics.Graphics;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
import pixi.flump.Sprite;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author Jordan Dachicourt
 */
class BuildingMenu extends Menu
{
	
	private static inline var BUILDING_INFO_NAME:String = "BuildingMenu_clipBuildingInfos";
	private static inline var BUILDING_ENERGY_BAR_NAME:String = "BuildingMenu_clipBarEnergy";
	private static inline var TEXT_ENERGY_BAR:String = "txt_energyDisplay";
	private static inline var CLOSE_BTN:String = "btn_Close";
	private static inline var BUILDING_BTN:String = "btn_Building";
	private static inline var SLIDER:String = "Slider";
	
	
	
	private var infoContainer:SmartComponent;
	private var energyBarContainer:SmartComponent;
	private var sliderContainer:SmartComponent;

	private var slider:Slider;
	public var panel:BuildingPanel;
	
	public static var saveCurrentIndex = 0;
	//affichage energy
	var lComponent:SmartComponent;
	var lTextField:TextSprite;
	var lMovieclipQuiFaitLErreur:SmartComponent;
	
	
	private var lastItemX:Float;
	private var firstItemX:Float;
	

	private var txtContainer:SmartText;
	


	/**
	 * instance unique de la classe BuildingMenu
	 */
	private static var instance: BuildingMenu;

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): BuildingMenu
	{
		if (instance == null) instance = new BuildingMenu();
		return instance;
	}

	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	override private function new(pID:String=null)
	{
		super(pID);
	}

	
	/**
	 * Initialise le BuildingMenu, recupere tout les container
	 */
	override private function init()
	{

		super.init();
		currentIndex = saveCurrentIndex;
		//buildingEnergyBarContainer = cast(getChildByName(BUILDING_ENERGY_BAR_NAME), SmartComponent);
		initTab(BuildingMenuSwitchTab);
		initItems();
		infoContainer = cast(getChildByName(BUILDING_INFO_NAME), SmartComponent);
		panel = new BuildingPanel();
		panel.init(infoContainer);
		ftueRegister();
		SmartPopinRegister.event.emit("onInit");
		
	}

	/*	######### ITEMS DU MENU ######### */
	
	
	/**
	 * stock les item du popin dans un tableau de reference
	 */
	override private function initItems() {
		sliderContainer = cast(getChildByName(SLIDER), SmartComponent);
		itemContainer = cast(sliderContainer.getChildByName(ITEM_CONTAINER), SmartComponent);
		itemContainer.interactive = true;
		
		initOffsetBetweenItems();
		
		slider = new Slider();
		slider.init(sliderContainer, itemContainer);
		
		updateItems();
	}
	
	/**
	 * Créer les items et les places
	 */
	public function updateItems() {
		destroyAllChildInContainer(itemContainer);
		saveCurrentIndex = currentIndex;
		for (i in 0 ... BuildingMenuData.getInstance().datas[currentIndex].length) {
			var currentItemInfo:BuildingMenuParams = BuildingMenuData.getInstance().datas[currentIndex][i];
			var currentItem = new BuildingMenuSwitchItem();
			itemContainer.addChild(currentItem);
			currentItem.x = offsetItem.x * i;
			currentItem.setInfo(currentItemInfo);
			currentItem.id = i;
			FTUEManager.register(currentItem);
		}
		
		slider.update();
	}

	public function updateEnergy():Void
	{
		/*lComponent = cast(getChildByName(BUILDING_ENERGY_BAR_NAME), SmartComponent);
		lTextField = cast(lComponent.getChildByName(TEXT_ENERGY_BAR), TextSprite);
		lTextField.text = Std.string(Player.getInstance().currentEnergy) + "/" + Std.string(Player.getInstance().maxEnergy);*/
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void
	{
		instance = null;
	}

}