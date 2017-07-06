package com.isartdigital.ruby.game.world;
import com.isartdigital.ruby.game.controller.Controller;
import com.isartdigital.ruby.game.sprites.elements.Building;
import com.isartdigital.ruby.game.sprites.elements.GameElement;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienIncubator;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienPaddock;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienTrainingCenter;
import com.isartdigital.ruby.game.sprites.elements.aliens.AlienElement;
import com.isartdigital.ruby.game.sprites.elements.destructible.Destructible;
import com.isartdigital.ruby.game.sprites.elements.drillingbuilding.DrillingBuilding;
import com.isartdigital.ruby.juicy.bullesxp.Bulle;
import com.isartdigital.ruby.ui.UIManager;
import com.isartdigital.ruby.ui.hud.Hud;
import com.isartdigital.ruby.ui.popin.Deplacement;
import com.isartdigital.ruby.ui.popin.SmartPopinRegister;
import com.isartdigital.ruby.ui.popin.TimeBased;
import com.isartdigital.ruby.ui.popin.centreForage.CentreForage;
import com.isartdigital.ruby.ui.popin.DynamicPopin;
import com.isartdigital.ruby.ui.popin.XenosPanel;
import com.isartdigital.ruby.ui.popin.contextual.BuildingContextualMenu;
import com.isartdigital.ruby.ui.popin.building.BuildingMenu;
import com.isartdigital.ruby.ui.popin.incubator.Incubator;
import com.isartdigital.ruby.ui.popin.codex.Codex;
import com.isartdigital.ruby.ui.popin.shop.Shop;
import com.isartdigital.utils.game.Camera;
import com.isartdigital.ruby.utils.Focus;
import com.isartdigital.utils.game.iso.IsoManager;
import com.isartdigital.utils.game.pooling.PoolObject;
import com.isartdigital.utils.sounds.SoundManager;
import js.Browser;
import js.Lib;
import pixi.core.math.Point;



/**
 * Classe servant à gérer toutes les intéraction du joueur avec les éléments ingame
 * @author Michael Wilkins
 */
class MapInteractor
{

	/**
	 * instance unique de la classe MapInteractor
	 */
	private static var instance: MapInteractor;

	private var isClicked:Bool = false;
	private var isCameraLocked:Bool = false;

	public var doAction:Void->Void;
	
	private var openMenuHasBeenRequested:Bool = false;

	private var lastBuildingHovered: Building;
	private var movingAlienMode = false;
	
	private var gameElemWhichWantsToOpenMenu:GameElement;
	
	public var modalPopinOpened:Bool = false;
	
	public var alienSelected:AlienElement;
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): MapInteractor
	{
		if (instance == null) instance = new MapInteractor();
		return instance;
	}

	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new()
	{
		doAction = doActionNormal;
	}

	private function doActionNormal():Void
	{
		
		checkBuildingHover();

		if (!Controller.isTap && isClicked) isClicked = false;

		if (Controller.getInstance().getMouseRegion() != null)
		{
			if (Controller.isTap && Controller.getInstance().getMouseRegion().isActive && !isClicked && Spawner.getInstance().toSpawn == null)
			{

				isClicked = true;

				if (gameElemUnderMouse() != null) openInfoPanel();
				else closeInfoPanel();
			}
		}
	}
	
	

	private function doActionSpawner():Void
	{

		Spawner.getInstance().doAction();
	}

	private function gameElemUnderMouse():GameElement
	{
		var currRegion:Region = Controller.getInstance().getMouseRegion();
		if (currRegion == null) return null;

		var lPoint:Point = Controller.getInstance().getPosFrom(Controller.getInstance().getMouseRegion().layers[1].container);
		lPoint = IsoManager.localToModel(lPoint);

		
		var lDataGameElem:GameElement = Controller.getInstance().getMouseRegion().layers[1].getCell(cast(lPoint.y, Int), cast(lPoint.x, Int));

		if (lDataGameElem == null) return null;
		


		var lGraphicGameElem:GameElement = getGraphicBuildingWithDataBuilding(lDataGameElem);


		return lGraphicGameElem;
	}

	private function getGraphicBuildingWithDataBuilding(pDataBuilding:GameElement):GameElement
	{

		for (i in 0...PoolObject.activeObjectList.length)
		{
			if (!Std.is(PoolObject.activeObjectList[i], Bulle))
			{
				var lGraphicBuilding = cast(PoolObject.activeObjectList[i], GameElement);


				if (lGraphicBuilding.hasSameCoordonatesAs(pDataBuilding))
				{
					return lGraphicBuilding;
				}
			}

		}
		return null;
	}
	
	
	private function openXenoPanel():Void 
	{
		UIManager.getInstance().openPopin(XenosPanel.getInstance());
	}
	


	public function closeInfoPanel():Void
	{
		
		UIManager.getInstance().closeCurrentPopin();
		
	}

	private function openInfoPanel():Void
	{


		if (!Std.is(gameElemUnderMouse(), Destructible))
		{
			var lBuilding:Building = cast(gameElemUnderMouse(), Building);
			
			if (lBuilding.currentState != lBuilding.CONSTRUCTING_STATE && lBuilding.currentState != lBuilding.UPGRADING_STATE) {
				
				if (!movingAlienMode) {
					openContextual();
				}
				else {
					
					if (lBuilding.canReceiveAliens) {
					
						UIManager.getInstance().closeAllPopins();
						if (Std.is(lBuilding, AlienIncubator)) stopAlienMode();
						for (paddock in AlienPaddock.alienPaddockList) {
							if (paddock.instanceID == alienSelected.idBuilding) cast(paddock.instance, AlienPaddock).removeAlien(alienSelected);
						}
						if (Std.is(lBuilding, AlienPaddock)) cast(lBuilding, AlienPaddock).addAlien(alienSelected);
						if (Std.is(lBuilding, AlienTrainingCenter)) cast(lBuilding, AlienTrainingCenter).addAlien(alienSelected);
						
					}
				}
				
			}
			
			else openTimeBased(lBuilding);
			
		}

		else if (!movingAlienMode)
		{
			DynamicPopin.getInstance().init("destroy item for " + gameElemUnderMouse().elem.softCurrency + " coins ?", cast(gameElemUnderMouse(), Destructible).destructionDB);
			UIManager.getInstance().openPopin(DynamicPopin.getInstance());
		}

		//if (Std.is(gameElemUnderMouse(), DrillingCenter)) UIManager.getInstance().openPopin(CentreForage.getInstance());

	}
	
	public function openInfoPaddock(pPaddock:AlienPaddock):Void {
	
		
	}
	
	private function openTimeBased(lBuilding:Building):Void {
	
		UIManager.getInstance().openPopin(TimeBased.getInstance());
		TimeBased.getInstance().setText(lBuilding);
	}

	private function openContextual() {
		
			
			
			if (!cast(gameElemUnderMouse(), Building).contextualOpened) {
				UIManager.getInstance().closeAllPopins();
				cast(gameElemUnderMouse(), Building).contextualOpened = true;
				UIManager.getInstance().openPopin(BuildingContextualMenu.getInstance());
				BuildingContextualMenu.getInstance().target = cast(gameElemUnderMouse(), Building);
				BuildingContextualMenu.getInstance().init();
				BuildingContextualMenu.getInstance().update();
				if (Std.is(gameElemUnderMouse(), AlienPaddock)) openXenoPanel();
			
				
			}
			
			else UIManager.getInstance().closeAllPopins();
	}
			
	public function highLightAlienBuildings():Void {
		
		movingAlienMode = true;
		Hud.getInstance().maskButtons();
		UIManager.getInstance().closeAllPopins();
		UIManager.getInstance().openPopin(Deplacement.getInstance());
		for (i in 0...PoolObject.activeObjectList.length)
		{
			if (Std.is(PoolObject.activeObjectList[i], Building)) {
				var lBuilding = cast(PoolObject.activeObjectList[i], Building);
				if (!lBuilding.canReceiveAliens) lBuilding.applyGreyFilter();
			}
			else if (Std.is(PoolObject.activeObjectList[i], Destructible)) {
				
				var lDestructible = cast(PoolObject.activeObjectList[i], Destructible);
				lDestructible.applyGreyFilter();
			}
			
		}
		
		for (lMap in World.getInstance().worldMap) 
			{
				for (lRegion in lMap) 
				{
					if (lRegion.isActive) lRegion.background.applyGreyFilter();
				}
			}
	}

	
	public function stopAlienMode():Void {
	
		Hud.getInstance().unmaskButtons();
		movingAlienMode = false;
		XenosPanel.getInstance().alienSelected = null;
		for (i in 0...PoolObject.activeObjectList.length)
		{
			if (Std.is(PoolObject.activeObjectList[i], Building)) {
				var lBuilding = cast(PoolObject.activeObjectList[i], Building);
				if (!lBuilding.canReceiveAliens) lBuilding.removeGreyFilter();
			}
			else if (Std.is(PoolObject.activeObjectList[i], Destructible)) {
				
				var lDestructible = cast(PoolObject.activeObjectList[i], Destructible);
				lDestructible.removeGreyFilter();
			}
			
		}
		
		for (lMap in World.getInstance().worldMap) 
			{
				for (lRegion in lMap) 
				{
					if (lRegion.isActive) lRegion.background.removeGreyFilter();
				}
			}
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void
	{
		instance = null;
	}

	private function checkBuildingHover():Void
	{

		if (!movingAlienMode) {
			if (!modalPopinOpened)
			{
				
				if (gameElemUnderMouse() != null && !Std.is(gameElemUnderMouse(), Destructible) && gameElemUnderMouse().currentState != gameElemUnderMouse().UPGRADING_STATE && gameElemUnderMouse().currentState != gameElemUnderMouse().CONSTRUCTING_STATE  )
				{
				lastBuildingHovered = cast(gameElemUnderMouse(), Building);
				lastBuildingHovered.applyHoverFilter();
				}

				else if (lastBuildingHovered != null)
				{
					lastBuildingHovered.removeHoverFilter();
					lastBuildingHovered = null;
			
				}
			}
			
			
		}
		
		else {
			
			if (gameElemUnderMouse() != null && !Std.is(gameElemUnderMouse(), Destructible))
			{
				lastBuildingHovered = cast(gameElemUnderMouse(), Building);
				if(lastBuildingHovered.canReceiveAliens) lastBuildingHovered.applyAllowedFilter();
			}

			else if (lastBuildingHovered != null)
			{
			
				if(lastBuildingHovered.canReceiveAliens) lastBuildingHovered.removeAllowedFilter();
				lastBuildingHovered = null;
			
			}
		
		}
		
	}

	public function activateSpawner():Void
	{
		if (Spawner.getInstance().toSpawn != null) doAction = doActionSpawner;
		else Browser.alert("SPAWNER ACTIVATED WHILE TOSPAWN DOESN'T EXIST");
	}

	public function deactivateSpawner():Void
	{

		if (Spawner.getInstance().toSpawn == null) doAction = doActionNormal;
		else Browser.alert("SPAWNER DEACTIVATED WHILE TOSPAWN EXISTS");
	}

}