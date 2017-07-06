package com.isartdigital.ruby.game;
import com.isartdigital.ruby.game.controller.Controller;
import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.game.sprites.FlumpStateGraphic;
import com.isartdigital.ruby.game.sprites.elements.Building;
import com.isartdigital.ruby.game.sprites.elements.GameElement;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienPaddock;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.BuildingEnergyProducer;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.UrbanAntenna;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.UrbanPowerStation;
import com.isartdigital.ruby.utils.ParticleManager;
import com.isartdigital.ruby.game.world.MapInteractor;
import com.isartdigital.ruby.game.world.Region;
import com.isartdigital.ruby.game.world.World;
import com.isartdigital.ruby.juicy.bullesxp.BullesManager;
import com.isartdigital.ruby.ui.UIManager;
import com.isartdigital.ruby.ui.ftue.FTUEManager;
import com.isartdigital.ruby.ui.ftue.FocusManager;
import com.isartdigital.ruby.ui.hud.Hud;
import com.isartdigital.ruby.ui.popin.ConfirmationPose;
import com.isartdigital.ruby.ui.popin.Deplacement;
import com.isartdigital.ruby.ui.popin.SmartPopinRegister;
import com.isartdigital.ruby.ui.popin.contextual.YesNoPose;
import com.isartdigital.ruby.ui.popin.building.BuildingMenu;
import com.isartdigital.ruby.utils.ColorFilterManager;
import com.isartdigital.ruby.utils.SmartShaker;
import com.isartdigital.ruby.utils.SmartShaker.ShakerParams;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.Camera;
import com.isartdigital.ruby.utils.Focus;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.clipping.CellManager;
import com.isartdigital.utils.game.clipping.IClippable.Element;
import com.isartdigital.utils.game.iso.IsoManager;
import com.isartdigital.utils.game.pooling.PoolManager;
import com.isartdigital.utils.game.pooling.PoolObject;
import com.isartdigital.utils.save.DataBaseAction;
import com.isartdigital.utils.save.DataManager;
import com.isartdigital.utils.sounds.SoundManager;
import js.Browser;
import js.Lib;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject;
import pixi.core.graphics.Graphics;
import pixi.core.math.Point;
import pixi.core.textures.Texture;



/**
 * Classe gérant la création, la pose et le déplacement de batiments sur la carte
 * @author Michael Wilkins
 */

 
 
 
class Spawner extends DisplayObject
{
	public var toSpawn:GameElement;
	private var ftueTargetingElement:GameElement;
	//public var graphicMargin:Graphics;
	
	
	public var isPayingWithHC:Bool = false;
	
	public var currentRegion:Region;
	
	
	private var isUnfixRequested:Bool = false;
	private var isElementToSpawnFixed:Bool = false;
	private var isCameraLockingDone:Bool = true;
	private var isCameraUnlockingDone:Bool = true;
	private var centerOfScreen:DisplayObject = new DisplayObject();
	private var currentAsset:String;
	private var globalPosition:Point;
	
	public var justMovingaBuilding:Bool = false;
	
	public var godMode:Bool = GameManager.getInstance().godMode;
	/**
	 * instance unique de la classe Spawner
	 */
	private static var instance: Spawner;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Spawner {
		if (instance == null) instance = new Spawner();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pAsset:String=null) 
	{
		super();
		currentRegion = World.getInstance().getRegion(0, 0);	
		
		
	}
	
	
	public function doAction():Void {
		
		isElementToSpawnFixed ? fixedMode() : dragMode();
		
	}
	
	private function dragMode():Void {
		//lockCamera();
		makeElementToSpawnFollowMouse();
		
		isNotObstructed() ? toSpawn.removeRedFilter() : toSpawn.applyRedFilter();
		
		if(!isUnfixRequested) {
			if (Controller.shortClic) {
			
			isNotObstructed() ? fixElementToSpawn() : launchObstructedFeedback();
			}
		}
		
		else {
		
			if (Controller.shortClic) {
				
				isUnfixRequested = false;
			}
		}
		
		
	}
	
	private function fixedMode():Void {
		if (Controller.shortClic) {
			SoundManager.getSound("soundPlayerCrossV2").play();
			if (!FTUEManager.isFTUEon()) {
				makeElementToSpawnFollowMouse();
				justMovingaBuilding ? openMovePopin() : openSpawnPopin();
			}
			if (!isNotObstructed()) {
				launchObstructedFeedback();
				unfixElementToSpawn();
			}
			
		}
	}
	
	
	private function fixElementToSpawn():Void {
		isElementToSpawnFixed = true;
		justMovingaBuilding ? openMovePopin() : openSpawnPopin();
		toSpawn.alpha = 1;
		isCameraLockingDone = false;
		
		SoundManager.getSound("soundPlayerCrossV2").play();
		currentAsset = toSpawn.CONSTRUCTING_STATE;
		toSpawn.changeAsset(currentAsset);
		
		toSpawn.on(MouseEventType.MOUSE_DOWN, unfixElementToSpawn);
		toSpawn.on(TouchEventType.TOUCH_START, unfixElementToSpawn);
		
	}
	
	private function unfixElementToSpawn():Void {
		isUnfixRequested = true;
		isElementToSpawnFixed = false;
		toSpawn.alpha = 0.5;
		isCameraLockingDone = false;
		UIManager.getInstance().closeAllPopins();
		currentAsset = toSpawn.SPAWNING_STATE;
		toSpawn.changeAsset(currentAsset);
		SoundManager.getSound("soundPlayerClic").play();
		toSpawn.off(MouseEventType.MOUSE_DOWN, unfixElementToSpawn);
		toSpawn.off(TouchEventType.TOUCH_START, unfixElementToSpawn);
		
		
	}
	
		
	
	public function setElementToSpawn(pElement:String):Void {
		if (toSpawn != null) toSpawn.dispose();
		toSpawn = cast(PoolManager.getFromPool(pElement), Building);	
		//nice2have ftue 
		/*if (FTUEManager.isFTUEon()) ftueTargetingElement = cast(PoolManager.getFromPool(pElement), Building);
		else ftueTargetingElement = null;*/
		if (canAffordIt()) displayElementToSpawn();
	}
	
	private function placeFtue():Void {
	
		var lModelPoint:Point = new Point(10, 10);
		toSpawn.changePosition(cast(lModelPoint.x, Int), cast(lModelPoint.y, Int)); 
		
	    if (!isNotObstructed()) lModelPoint = pointWhereThereIsRoom();
		
		var lGlobalModelPoint:Point = new Point(0, 0);
		lGlobalModelPoint.x = currentRegion.x * Region.WIDTH + lModelPoint.x;
		lGlobalModelPoint.y = currentRegion.y * Region.HEIGHT + lModelPoint.y;
		
		
		var lGlobalIsoPoint = IsoManager.modelToIsoView(lGlobalModelPoint);
		
		setPosition(lGlobalIsoPoint);
		toSpawn.position = position;
		Focus.getInstance().position = position;
		fixElementToSpawn();
		
	}
	
	private function displayElementToSpawn():Void {
		UIManager.getInstance().closeAllPopins();
		currentRegion =  World.getInstance().getRegion(cast(Focus.getInstance().getRegionOn().x, Int), cast(Focus.getInstance().getRegionOn().y, Int));
		toSpawn.alpha = 0.5;
		currentAsset = toSpawn.SPAWNING_STATE;
		//GameStage.getInstance().getGameContainer().addChild(graphicMargin);
		GameStage.getInstance().getGameContainer().addChild(toSpawn);
		
		toSpawn.start();
		//FTUEManager.isFTUEon() ? placeFtue() : makeElementToSpawnFollowMouse();
		makeElementToSpawnFollowMouse();
		MapInteractor.getInstance().activateSpawner();
		checkForSpecialBehavior();
		
		//nice to have ( spawn du batiment dans le container ftue)
		//if (ftueTargetingElement != null) {
			//
			//
			//
			//GameStage.getInstance().getFtueContainer().addChild(ftueTargetingElement);
			//ftueTargetingElement.position = convertPositionInFtueContainer();
			//ftueTargetingElement.on(MouseEventType.MOUSE_DOWN, setDrag);
			//ftueTargetingElement.on(TouchEventType.TOUCH_START, setDrag);
		//}
		
		
		
	}
	
	private function openSpawnPopin():Void {
		var lCostSC:Int = cast(toSpawn, Building).costSC;
		var lCostMN:Int = cast(toSpawn, Building).costMN;
		var lCostHC:Int = cast(toSpawn, Building).costHC;
		globalPosition = new Point(0, 0);
		globalPosition.x = currentRegion.x * Region.WIDTH + toSpawn.colMin;
		globalPosition.y = currentRegion.y * Region.HEIGHT + toSpawn.rowMin;
		globalPosition = IsoManager.modelToIsoView(globalPosition);
		toSpawn.globalPosition = globalPosition;
		UIManager.getInstance().closeAllPopins();
		UIManager.getInstance().openPopin(ConfirmationPose.getInstance());
		ConfirmationPose.getInstance().target = cast(toSpawn, Building);
		ConfirmationPose.getInstance().init(toSpawn);
		ConfirmationPose.getInstance().updateValues(lCostSC, lCostMN, lCostHC);
	}
	
	private function openMovePopin():Void {
	
		UIManager.getInstance().closeAllPopins();
		UIManager.getInstance().openPopin(YesNoPose.getInstance());
		YesNoPose.getInstance().target = cast(toSpawn, Building);
	}
	
	public function moveBuilding(pBuilding:Building):Void {
	
		justMovingaBuilding = true;
		toSpawn = pBuilding;
		currentRegion = World.getInstance().getRegion(toSpawn.elem.regionX, toSpawn.elem.regionY); 
		
		makeElementToSpawnFollowMouse();
		unfixElementToSpawn();
		checkForSpecialBehavior();
		
		GameStage.getInstance().getGameContainer().addChild(toSpawn);
		toSpawn.position = position;
		
		MapInteractor.getInstance().activateSpawner();
	}
	
	
	
	private function placeBuildingOnTheGround(?isCanceled : Bool):Void {
	
		 
		toSpawn.off(MouseEventType.MOUSE_DOWN, unfixElementToSpawn);
		toSpawn.off(TouchEventType.TOUCH_START, unfixElementToSpawn);
		toSpawn.changeAsset(toSpawn.currentState);
		
		GameStage.getInstance().getGameContainer().removeChild(toSpawn);
		
		
		if (isCanceled) cast(toSpawn, Building).saveNewPosition(toSpawn.elem.x, toSpawn.elem.y, toSpawn.elem.regionX, toSpawn.elem.regionY);
		else cast(toSpawn, Building).saveNewPosition(toSpawn.colMin, toSpawn.rowMin);
		justMovingaBuilding = false;
		
		
		
		
		toSpawn = null;
		MapInteractor.getInstance().deactivateSpawner();
		Building.updateBuildingsCarac();
		
		UIManager.getInstance().closeAllPopins();
		
		
	}
	
	public function setSpawnerIsoPosition():Void {
		
		
		var lPosition:Point = Controller.getInstance().getPosFrom(GameStage.getInstance().getGameContainer());
		var lRegionContainer:Container;
		var lCooRegion:Point = Controller.getInstance().getPosRegion();
		if (World.getInstance().getRegion(cast(lCooRegion.x, Int), cast(lCooRegion.y, Int)) == null) return;
		if (!World.getInstance().getRegion(cast(lCooRegion.x, Int), cast(lCooRegion.y, Int)).isActive) return;
		setPosition(IsoManager.localToIso(lPosition));
		var lRegion = World.getInstance().getRegion(cast(lCooRegion.x, Int), cast(lCooRegion.y, Int));
		if (lRegion == null) return;
		
		
		
		//si on change de region
		if (lRegion != currentRegion) {
			currentRegion = lRegion;
			checkForSpecialBehavior();
		}
	}
	
	private function checkForSpecialBehavior():Void {
	
	if (Std.is(toSpawn, UrbanAntenna)) {
			
				var lHasLeveledPowerStation:Bool = false;
				for (station in currentRegion.powerStationsInRegion) {
				
					if (station.level == 2) lHasLeveledPowerStation = true;
				}
				if (lHasLeveledPowerStation) toSpawn.level = 2;
				else toSpawn.level = 1;
				toSpawn.changeAsset(currentAsset);
			}
	}
	private function positionElementToSpawn():Void {
	
		toSpawn.changePosition(cast(getPosInRegion().x, Int), cast(getPosInRegion().y, Int));
		toSpawn.position = position;
		
		//if (ftueTargetingElement != null) ftueTargetingElement.position = convertPositionInFtueContainer();
		
		
		if (Std.is(toSpawn, Building)) {
			if (cast(toSpawn, Building).timerContainer != null) cast(toSpawn, Building).timerContainer.position = position;
			
		}
		if (Std.is(toSpawn, AlienPaddock)) {
			if (cast(toSpawn, AlienPaddock).timerContainer != null) cast(toSpawn, AlienPaddock).prodContainer.position = position;	
		}
	}
	
	
	private function pointWhereThereIsRoom():Point {
	
		for (x in 0...Region.WIDTH) {
		
			for (y in 0...Region.HEIGHT) {
			
				toSpawn.changePosition(x, y); 
				if (isNotObstructed()) return new Point(x, y);
				
			}
		}
		
		return new Point(10, 10);
	}
	
	
	
	
	private function getPosInRegion():Point {
	
		var lCoorInRegion:Point = Controller.getInstance().getPosFrom(currentRegion.layers[1].container);
		lCoorInRegion = IsoManager.localToModel(lCoorInRegion);
		return lCoorInRegion;
	}
	
	private function isNotObstructed():Bool {
	
		if (currentRegion.powerStationsInRegion.length > 0 && Std.is(toSpawn, UrbanPowerStation)) {
		
			if (justMovingaBuilding) {
			
				if (currentRegion != World.getInstance().getRegion(toSpawn.elem.regionX, toSpawn.elem.regionY)) return false;
			}
			else return false;
		}
		
		
		if (currentRegion.powerStationsInRegion.length <= 0 && Std.is(toSpawn, UrbanAntenna)) return false;
		return currentRegion.layers[1].canAdd(toSpawn);
	}
	
	public function setPosition(pPosition:Point) : Void {
		position = pPosition;
	}
	
	
	private function canAffordIt():Bool {
	
		if (godMode) return true;
		else {
			
			var lHasEnoughEnergy:Bool = true;
			if (Std.is(toSpawn, Building) && !Std.is(toSpawn, UrbanAntenna) && !Std.is(toSpawn, UrbanPowerStation)) lHasEnoughEnergy = Player.getInstance().hasEnoughEnergy(cast(toSpawn, Building).energyCost);
			if (!lHasEnoughEnergy) {
				Hud.getInstance().noEnergyAnimation();
				return false;
			}
			var lHasEnoughSC:Bool = Player.getInstance().hasEnoughQuantity(cast(toSpawn, Building).costSC, Player.getInstance().softCurrency);
			var lHasEnoughMN:Bool = Player.getInstance().hasEnoughQuantity(cast(toSpawn, Building).costMN, Player.getInstance().ressource);
			var lHasEnoughHC:Bool = Player.getInstance().hasEnoughQuantity(cast(toSpawn, Building).costHC, Player.getInstance().hardCurrency);
			
			if ((!lHasEnoughMN || !lHasEnoughSC) && !lHasEnoughHC) {
				if (!lHasEnoughMN) Hud.getInstance().noMaterialAnimation();
	 			if (!lHasEnoughSC) Hud.getInstance().noSCAnimation();
				//Hud.getInstance().noHCAnimation(); // a voir si on garde (confusion?)
				return false;
			}
			
			if ((lHasEnoughMN && lHasEnoughSC) || lHasEnoughHC) {
			
				if (!lHasEnoughMN) ConfirmationPose.getInstance().noMN = true;
				if(!lHasEnoughHC) ConfirmationPose.getInstance().noHC = true;
				if (!lHasEnoughSC) ConfirmationPose.getInstance().noSC = true;
				
				return true;
			}
			
		}
		
		
		return false;
	}	
	
	public function cancel():Void {
		if (justMovingaBuilding) placeBuildingOnTheGround(true);
		else {
			if (toSpawn != null) {
		
			toSpawn.dispose();
			//GameStage.getInstance().getGameContainer().removeChild(graphicMargin);
			toSpawn = null;
			MapInteractor.getInstance().deactivateSpawner();
			isElementToSpawnFixed = false;
		}
		}
		
	
		
	}
	
	private function drawIsoMargin(pGraphic:Graphics, pGameObject:GameElement) {
		//graphicMargin.clear();
		//var lColor:Int;
		//if (isNotObstructed()) lColor = 0x06ff00;
		//else lColor = 0xff0000;
		//pGraphic.beginFill(lColor);
		//
		//var lStart = IsoManager.isoViewToModel(position);
		//var lMargin = pGameObject.margin;
		//var lWidth = pGameObject.localWidth;
		//var lHeight = pGameObject.localHeight;
		//var lIsoTop:Point = IsoManager.modelToIsoView(new Point(lStart.x - lMargin, lStart.y - lMargin));
		//var lIsoRight:Point = IsoManager.modelToIsoView(new Point(lStart.x + lWidth  + lMargin, lStart.y - lMargin));
		//var lIsoBottom:Point = IsoManager.modelToIsoView(new Point(lStart.x + lWidth + lMargin, lStart.y + lHeight + lMargin));
		//var lIsoLeft:Point = IsoManager.modelToIsoView(new Point(lStart.x - lMargin, lStart.y + lHeight + lMargin));
		//
		//pGraphic.drawPolygon
		//([
			//lIsoTop.x, lIsoTop.y,
			//lIsoRight.x, lIsoRight.y,
			//lIsoBottom.x, lIsoBottom.y,
			//lIsoLeft.x, lIsoLeft.y
        //]);	
		//
		//pGraphic.endFill();
	}
	
	public function onClick():Void {
		
		if (isNotObstructed()) {
			justMovingaBuilding ? placeBuildingOnTheGround() : spawnGameElement();
			toSpawn = null;
			//GameStage.getInstance().getGameContainer().removeChild(graphicMargin);
			DataManager.getInstance().save(PoolObject.elementList);
			MapInteractor.getInstance().deactivateSpawner();
			
		}
		
	}
	
	private function spawnGameElement():Void {
		
		var lClassName:String = Type.getClassName(Type.getClass(toSpawn)).split(".").pop();
		var lToSpawn:GameElement = cast(PoolManager.getFromPool(lClassName), GameElement);
		
		
		if (!godMode) {
			if (!isPayingWithHC) {
				Player.getInstance().changePlayerValue(-cast(lToSpawn, Building).costSC, Player.TYPE_SOFTCURRENCY, true);
				Player.getInstance().changePlayerValue(-cast(lToSpawn, Building).costMN, Player.TYPE_RESSOURCE, true);
			}
			else
			{
				Player.getInstance().changePlayerValue(-cast(lToSpawn, Building).costHC, Player.TYPE_HARDCURRENCY, true);
			}
		}
		createNewGameElement(lToSpawn, toSpawn.colMin, toSpawn.rowMin);
		UIManager.getInstance().closeAllPopins();
		
		
	}
	
	private function launchObstructedFeedback():Void {
	
		//var redParams:ColorFilterParams = 
		//{
			//colorAmount:1,
			//colorToApply: "red",
			//duration :1
		//}

		var shakeParams : ShakerParams = 
		{
			originalPosition: toSpawn.position.clone(),
			smoothness:5,
			amplitude:10,
			duration:40,
			xQuantity: 1.5,
			yQuantity: 0.5,
			fadeOut: 0.95,
			randomShake: true,
			sound:"no"
		}
		
		//ColorFilterManager.getInstance().applyFilter(toSpawn, redParams);
		SmartShaker.getInstance().SetShaker(toSpawn, shakeParams);
	}
	
	
	public function createNewGameElement(pGameElem:GameElement, pX:Int , pY:Int):Void 
	{
		var lInstanceID = newID(pGameElem.name);
		var lPoint:Point = new Point(pX, pY);
		pGameElem.position = IsoManager.modelToIsoView(lPoint);
		
		
		
		var lElem:Element = { instanceID : lInstanceID,
							type : pGameElem.name,
							width : pGameElem.width, 
							height : pGameElem.height, 
							x : pX,
							y : pY,
							globalX : globalPosition.x,
							globalY : globalPosition.y,
							regionX : currentRegion.x,
							regionY : currentRegion.y,
 							layer : 1,
							levelUpGrade : toSpawn.level,
							mode : pGameElem.CONSTRUCTING_STATE
							};
							
				
		pGameElem.init(lElem);
		pGameElem.start();
		
		
		
		//var shakeParams : ShakerParams = 
		//{
			//originalPosition: GameStage.getInstance().getGameContainer().position.clone(),
			//smoothness:3,
			//amplitude:10,
			//duration:30,
			//xQuantity: 1,
			//yQuantity: 0.5,
			//fadeOut: 0.95,
			//randomShake: true,
			//sound:"build"
		//}
		//SmartShaker.getInstance().SetShaker(GameStage.getInstance().getGameContainer(), shakeParams);
		
		cast(pGameElem, Building).addEnergyToPlayer();
		if (Std.is(pGameElem, BuildingEnergyProducer)) cast(pGameElem, BuildingEnergyProducer).increasePlayerMaxEnergy();
		
		currentRegion.layers[1].add(pGameElem);
		currentRegion.layers[1].container.addChild(pGameElem);
		
		PoolObject.elementList.set(lInstanceID, lElem);
		CellManager.getInstance().setCell(lElem);
		DataManager.getInstance().save(PoolObject.elementList);
		currentRegion.layers[1].container.children = IsoManager.sortTiles(currentRegion.layers[1].container.children);
		
		var lCost:Int;
		var lMNCost:Int = cast(pGameElem, Building).costMN;
		isPayingWithHC ? lCost = cast(pGameElem, Building).costHC : lCost = cast(pGameElem, Building).costSC;
		if (godMode) {
			lCost = 0;
			lMNCost = 0;
		}
		if (isPayingWithHC) DataBaseAction.getInstance().addBuildingAndChangeRessource(Player.getInstance().id, "hardCurrency", lCost, pGameElem.name, pGameElem.instanceID, currentRegion.x, currentRegion.y, pX, pY, globalPosition.x, globalPosition.y, 1);
		else DataBaseAction.getInstance().addBuildingAndChangeRessource(Player.getInstance().id, "softCurrency", lCost, pGameElem.name, pGameElem.instanceID, currentRegion.x, currentRegion.y, pX, pY, globalPosition.x, globalPosition.y, 1,lMNCost);
		
		//if (Std.is(pGameElem, UrbanAntenna)) {
			DataBaseAction.getInstance().changeBuildingLevel(lInstanceID, toSpawn.level);
		//}
		isPayingWithHC = false;
		
		SoundManager.getSound("soundPlayerStartCreateBuilding").play();
		
		Building.updateBuildingsCarac();
		//toSpawn.off(MouseEventType.MOUSE_DOWN, setDrag);
		//toSpawn.off(TouchEventType.TOUCH_START, setDrag);
		
		cancel();
		spwanEffect(cast(pGameElem, Building));


	}
	
	private function spwanEffect(pBuilding:Building):Void
	{
		var lParticle:Container = ParticleManager.getInstance().createParticle("bubble", ["bubble"], 5000);
		var lSmoke:Container = ParticleManager.getInstance().createParticle("smoke", ["smoke01","bubble","smoke03"], 5000);
		lParticle.position = new Point(pBuilding.position.x+pBuilding.width/4,pBuilding.position.y+pBuilding.height/4);
		lSmoke.position = new Point(pBuilding.position.x+pBuilding.width/4,pBuilding.position.y+pBuilding.height/4);
		GameStage.getInstance().getInfoBulleContainer().addChild(lParticle);
		GameStage.getInstance().getInfoBulleContainer().addChild(lSmoke);
		
		
	}
	
	public function newID(pType:String):String
	{
		var lInstanceID:String = pType + Date.now().getTime();
		return lInstanceID;
	}
	
	private function makeElementToSpawnFollowMouse():Void {
	
		setSpawnerIsoPosition();
		positionElementToSpawn();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}