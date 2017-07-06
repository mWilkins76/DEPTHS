package com.isartdigital.ruby.game.sprites.elements.alienbuilding;
import com.isartdigital.ruby.game.sprites.elements.Building;
import com.isartdigital.ruby.game.sprites.elements.aliens.Alien;
import com.isartdigital.ruby.game.sprites.elements.aliens.AlienElement;
import com.isartdigital.ruby.game.sprites.elements.aliens.alienspaddockable.AlienBuffer;
import com.isartdigital.ruby.game.sprites.elements.aliens.alienspaddockable.AlienBufferType;
import com.isartdigital.ruby.game.sprites.elements.aliens.alienspaddockable.AlienProducer;
import com.isartdigital.ruby.game.sprites.elements.drillingbuilding.DrillingAutoOutPost;
import com.isartdigital.ruby.game.sprites.elements.drillingbuilding.DrillingCenter;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.BuildingEnergyProducer;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.UrbanAntenna;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.UrbanPowerStation;
import com.isartdigital.ruby.game.world.MapInteractor;
import com.isartdigital.ruby.game.world.Region;
import com.isartdigital.ruby.game.world.World;
import com.isartdigital.utils.game.Camera;
import com.isartdigital.ruby.utils.ColorFilterManager;
import com.isartdigital.ruby.utils.RessourcesEffectManager;
import com.greensock.TweenLite;
import com.greensock.TweenMax;
import com.greensock.easing.Back;
import com.isartdigital.ruby.utils.RessourcesEffectManager.RessourceType;
import com.isartdigital.ruby.utils.RessourcesEffectManager.RessourcesEffectParams;
import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.game.sprites.elements.aliens.alienspaddockable.AlienPaddockable;
import com.isartdigital.ruby.game.sprites.ressources.Bubble;
import com.isartdigital.ruby.game.sprites.ressources.RessourceSoftCurrency;
import com.isartdigital.ruby.ui.UIManager;
import com.isartdigital.ruby.ui.hud.Hud;
import com.isartdigital.ruby.ui.popin.DynamicPopin;
import com.isartdigital.utils.Config;
import com.isartdigital.ruby.utils.SmartShaker;
import com.isartdigital.ruby.utils.SmartShaker.ShakerParams;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.clipping.IClippable.Element;
import com.isartdigital.utils.game.iso.IsoManager;
import com.isartdigital.utils.save.DataBaseAction;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.SmartText;
import eventemitter3.EventEmitter;
import haxe.Timer;import com.isartdigital.utils.ui.smart.SmartComponent;import pixi.core.graphics.Graphics;
import js.Browser;
import pixi.core.math.Point;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;

/**
 * ...
 * @author Michael Wilkins
 */
class AlienPaddock extends Building
{
	
	public static var alienPaddockList:Array<Element> = new Array<Element>();
	private var alienProds:Array<AlienProducer>;
	private var alienBuffers:Array<AlienBuffer>;
	public var totalAliens:Array<AlienElement>;
	public var prodContainer:SmartText;
	private var hardToSkip:Int = 3;
	private var isFilled:Bool;
	private var currentRessources:Float = 0;
	private var maxRessources:Float = 0;
	private var buildingBuffedList:Array<Building> = new Array<Building>();
	private var buffAera:Graphics;
	private var buffAeraSize:Int = 3;
	public var room:Int;
	public static var event:EventEmitter = new EventEmitter();
	
	
	public function new(pAsset:String=null)
	{
		super(pAsset);
		buildingName = "Paddock";
		description = "Permet de placer des Xénos pour qu'ils produisent de l'or.";
		alienProds = new Array<AlienProducer>();
		alienBuffers = new Array<AlienBuffer>();
		totalAliens = new Array<AlienElement>();
		canReceiveAliens = true;
		
		
	}
	
	public function addAlien(pAlienElem:AlienElement):Void {
		
		for (alien in totalAliens) if (pAlienElem == alien) {
			MapInteractor.getInstance().stopAlienMode();
			return;
		}
	
		if (totalAliens.length >= room) {
			MapInteractor.getInstance().stopAlienMode();
			Browser.alert("Plus de place dans l'enclos");
		}
		else {
			pAlienElem.idBuilding = elem.instanceID;
			DataBaseAction.getInstance().changeAlienIdBuilding(pAlienElem.idAlien, pAlienElem.idBuilding);
			MapInteractor.getInstance().stopAlienMode();
			//SoundManager.getSound("soundPlayerPutXenos").play();
			displayAliens();
		}
		
		event.emit("onAddAlien");
	}
	
	public function removeAlien(pAlienElem:AlienElement):Void {
	
		pAlienElem.idBuilding = "no Building";
		DataBaseAction.getInstance().changeAlienIdBuilding(pAlienElem.idAlien, pAlienElem.idBuilding);
		totalAliens.splice(totalAliens.indexOf(pAlienElem), 1);
		if (pAlienElem.type == "AlienBuffer") removeBuffer(pAlienElem);
		else if (pAlienElem.type == "AlienProducer") removeProducer(pAlienElem);
		SoundManager.getSound("soundPlayerRetakeXenos").play();
		displayAliens();
	}
	
	private function removeBuffer(pAlienElem:AlienElement):Void {
	
		var lLength:Int = alienBuffers.length;
		for (i in 0...lLength) {
		
			if (alienBuffers[i].aElem == pAlienElem) {
				GameStage.getInstance().getAlienContainer().removeChild(alienBuffers[i]);
				alienBuffers.splice(alienBuffers.indexOf(alienBuffers[i]), 1);
				SoundManager.getSound("soundPlayerSelectXenosBomber").play();
				return;
				
			}
		}
	}
	
	private function removeProducer(pAlienElem:AlienElement):Void {
	
		var lLength:Int = alienProds.length;
		for (i in 0...lLength) {
		
			if (alienProds[i].aElem == pAlienElem) {
				GameStage.getInstance().getAlienContainer().removeChild(alienProds[i]);
				alienProds.splice(alienProds.indexOf(alienProds[i]), 1);
				SoundManager.getSound("soundPlayerSelectXenosForeur").play();
				return;
				
			}
		}
	}

	//initialisation
	override public function init(?pElem:Element=null):Void
	{
	
		super.init(pElem);
		
		if (alienPaddockList.indexOf(this.elem) == -1) alienPaddockList.push(this.elem);
		
		displayAliens();
	}
	
	private function displayAliens():Void {
	
		for (i in 0...Alien.alienElementList.length) {
		
			var lAlienElem: AlienElement = Alien.alienElementList[i];
			if (lAlienElem.idBuilding == instanceID) createAlien(lAlienElem);
		}
	}
	
	
	
	
	private function createAlien(pAlienElem:AlienElement):Void {
		
		
		totalAliens.push(pAlienElem);
		
		var lIndex:Int = totalAliens.indexOf(pAlienElem);
		
		
		// DRYIFIER
		if (pAlienElem.type == "AlienBuffer") {
			var lAlien:AlienBuffer = new AlienBuffer();
			lAlien.setElem(pAlienElem);
			GameStage.getInstance().getAlienContainer().addChild(lAlien);
			lAlien.start();
			lAlien.ownPaddock = this;
			lAlien.position = setPosition(lIndex);
			var isoPos:Point = IsoManager.isoViewToModel(setPosition(lIndex));
			lAlien.setPosition(isoPos);
			alienBuffers.push(lAlien);
			SoundManager.getSound("soundPlayerChooseXenosForeur").play();
		}
		if (pAlienElem.type == "AlienProducer") {
			var lAlien:AlienProducer = new AlienProducer();
			lAlien.setElem(pAlienElem);
			GameStage.getInstance().getAlienContainer().addChild(lAlien);
			lAlien.start();
			lAlien.ownPaddock = this;
			lAlien.position = setPosition(lIndex);
			var isoPos:Point = IsoManager.isoViewToModel(setPosition(lIndex));
			lAlien.setPosition(isoPos);
			alienProds.push(lAlien);
			checkForContainer();
			
		}
		SoundManager.getSound("soundPlayerChooseXenosBomber").play();
	}
	
	private function setPosition(pIndex:Int):Point {
	
		return new Point(elem.globalX, elem.globalY);
	}

	//machine à état
	override private function setModeNormal():Void
	{
		checkForContainer();
		super.setModeNormal();

	}
	
	
	private function checkForContainer():Void {
	
		
		if (alienProds.length > 0) 
		{		
			
		}
		
		
		
	}
	
	override private function doActionNormal():Void
	{
		super.doActionNormal();
		var lTotalRessources:Float = 0;
		var lTotalMaxProd:Float = 0;
		
		for (alien in alienProds)
		{
			alien.doAction();
			lTotalRessources += alien.ressources;
			lTotalMaxProd += alien.maxProduction;		
		}
		
		if (lTotalMaxProd != maxRessources || lTotalRessources != currentRessources) {
			currentRessources = lTotalRessources;
			maxRessources = lTotalMaxProd;
		}
		if (alienProds.length > 0 && areTheyAllFilled()) {
		}
	}
	
	public function areTheyAllFilled():Bool {
		for (alien in alienProds) {
			if (!alien.isFilled) return false;
		}
		
		return true;
	}

	public function setModeCollectable():Void
	{
		changebuttonToCollect();
		isFilled = true;
		doAction = doActionCollectable;
		
	}

	private function doActionCollectable()
	{
		for (alien in alienProds) alien.doAction();
	}

	//methodes

	/**
	 * ajoute un ecouteur de clic sur prodContainer
	 */
	private function changebuttonToCollect():Void
	{
		trace("harvest");
	}

	/**
	 * met un ecouteur sur les ressources
	 */
	private function addBtnSkipCooldown():Void
	{
		prodContainer.on(MouseEventType.CLICK, onSkipCooldown);
	}

	/**
	 * ouvre la popin de confirmation et l'initialise
	 */
	private function onSkipCooldown():Void
	{
		UIManager.getInstance().openPopin(DynamicPopin.getInstance());
		DynamicPopin.getInstance().init("skip cooldown with "+ hardToSkip + " hard currency ?", cooldownSkiped);
	}
	
	/**
	 * skip le cooldown et retire la hardCurrency si le joueur en a assez
	 */
	private function cooldownSkiped():Void 
	{
		
		isFilled = true;
		if (Player.getInstance().hasEnoughQuantity(hardToSkip, Player.getInstance().hardCurrency))
		{
			for (alien in alienProds) alien.isFilled = true;
			Player.getInstance().changePlayerValue( -hardToSkip, Player.TYPE_HARDCURRENCY);
			
			cooldownSkipedAnimation();
		}
		else	
			Hud.getInstance().noHCAnimation();
		
	}

	/**
	 * callback du clic sur le prodContainer
	 */
	public function onCollect():Void
	{
		isFilled = false;		
		collect();
		setModeNormal();
	}
	
	private function collect() {
				
		var lAllRessources:Float = 0;
		SoundManager.getSound("soundPlayerHarvest").play();
		ressourceCollectAnimation();
		
		for (alien in alienProds){
			lAllRessources += alien.ressources;
			alien.isFilled = false;
		}
		
		Player.getInstance().changePlayerValue(lAllRessources, Player.TYPE_SOFTCURRENCY);
	}
	
	private function cooldownSkipedAnimation() {
		var ressourceHCgoToBuilding : RessourcesEffectParams = 
			{
				originalPosition: GameStage.getInstance().getHudContainer().toLocal(Hud.getInstance().hcAddButton.parent.toGlobal(Hud.getInstance().hcAddButton.position.clone())),
				destinationPosition : GameStage.getInstance().getHudContainer().toLocal(parent.toGlobal(position.clone())),
				whereToAddchild: GameStage.getInstance().getHudContainer(),
				numObjectsToInstanciate: hardToSkip,
				duration:1,
				secondsBtwnaddchilds:1,
				speed:0.2,
				animationType:"dispersionToCurve",
				ressource: RessourceType.HardCurrency,
			}

			RessourcesEffectManager.getInstance().SetEffect(ressourceHCgoToBuilding);
	}
	
	private function ressourceCollectAnimation() {
		var ressourceSCgoToHud : RessourcesEffectParams = 
			{
				originalPosition: GameStage.getInstance().getHudContainer().toLocal(parent.toGlobal(position.clone())),
				destinationPosition : GameStage.getInstance().getHudContainer().toLocal(Hud.getInstance().scAddButton.parent.toGlobal(Hud.getInstance().scAddButton.position.clone())),
				whereToAddchild: GameStage.getInstance().getHudContainer(),
				numObjectsToInstanciate: 20,
				duration:1,
				secondsBtwnaddchilds:1,
				speed:0.2,
				animationType:"dispersionToCurve",
				ressource: RessourceType.SoftCurrency,
			}

		RessourcesEffectManager.getInstance().SetEffect(ressourceSCgoToHud);
	}

	/**
	 * Ajoute un alien au batiment
	 * @param	pType : nom de class de l'alien
	 */
	private function addProducer(pType:String) :Void
	{
		var lAlien:AlienProducer = new AlienProducer();
		alienProds.push(lAlien);
	}
	
	private function addBuffer(pName:String):Void 
	{
		var lBuffer:AlienBuffer = new AlienBuffer(pName);
		lBuffer.initBuff();
		alienBuffers.push(lBuffer);
		if (buffAeraSize != null) buffAeraSize = 3;
	}
	
	
	
	/**
	 * recupère les building dans la zone de buff
	 * @param	pBuffAera : zone de buff
	 */
	public function getBuildingOnAera(?pIsFirstLoad:Bool = false):Void {
		var listBuildingCanBeBuff:Array<Building> = new Array<Building>();
		var lRegion:Region = World.getInstance().getRegion(elem.regionX, elem.regionY);
		lRegion.layers[1].getCell(elem.x, elem.y);
		var xMin:Int = colMin - buffAeraSize;
		var xMax:Int = colMax + buffAeraSize;
		var yMin:Int = rowMin - buffAeraSize;
		var yMax:Int = rowMax + buffAeraSize;
		for (x in xMin...xMax+1	)
		{
			for ( y in yMin...yMax+1)
			{
				if (lRegion.layers[1].getCell(x, y) != null)
				{
					var lBuilding:Building = cast(lRegion.layers[1].getCell(x, y), Building);
					if (Std.is(lBuilding, AlienPaddock)) continue;
					if (listBuildingCanBeBuff.indexOf(lBuilding) == -1 && isBuildingCanBeBuff(lBuilding)) listBuildingCanBeBuff.push(lBuilding);
				}
			}
		}
		if (buildingBuffedList != listBuildingCanBeBuff && !pIsFirstLoad) updateBuildingBuffedList(listBuildingCanBeBuff);
		else if(pIsFirstLoad) buildingBuffedList = listBuildingCanBeBuff;
	}
	
	/**
	 * met à jour la liste de building buff en fonction de la liste de building a buff
	 * @param	pArray
	 */
	private function updateBuildingBuffedList(pArray:Array<Building>):Void
	{
		var lBuilding:Building;
		var lBuildingToDebuff:Array<Building> = new Array<Building>();
		var lBuildingToBuff:Array<Building> = new Array<Building>();
		
		var i:Int = buildingBuffedList.length -1;
		while (i >= 0) 
		{
			lBuilding = buildingBuffedList[i];
			if (pArray.indexOf(lBuilding) == -1) 
			{
				lBuildingToDebuff.push(lBuilding);
				buildingBuffedList.remove(lBuilding);
			}
			i--;
		}
		for (i in 0...pArray.length)
		{
			lBuilding = pArray[i];
			if (buildingBuffedList.indexOf(lBuilding) == -1) 
			{
				lBuildingToBuff.push(lBuilding);
				buildingBuffedList.push(lBuilding);
			}
		}
		AddOrRemoveBuff(lBuildingToDebuff, false);
		AddOrRemoveBuff(lBuildingToBuff, true);
	}
	
	/**
	 * Modifie le comportement des building a buff ou debuff
	 * @param	pArray : liste de building a buff
	 * @param	isAdd : true pour ajouter un buff, false pour le retirer
	 */
	private function AddOrRemoveBuff(pArray:Array<Building>, ?isAdd:Bool = true):Void
	{
		for (alien in alienBuffers)
		{
			if (alien.buffType == "energy") 
			{
				for (building in pArray) 
				{
					if (Std.is(building, BuildingEnergyProducer))
					{
						cast(building, BuildingEnergyProducer).Buff(alien.buffCoef, isAdd);
					}
				}
			}
			else if (alien.buffType == "darkMater")
			{
				for (building in pArray) 
				{
					if (Std.is(building, DrillingAutoOutPost) || Std.is(building, DrillingCenter))
					{
						cast(building, BuildingEnergyProducer).Buff(alien.buffCoef, isAdd);
					}
				}				
			}
			else if (alien.buffType == "gene")
			{
				for (building in pArray) 
				{
					if (Std.is(building, DrillingAutoOutPost) || Std.is(building, DrillingCenter)) 
					{
						cast(building, BuildingEnergyProducer).Buff(alien.buffCoef, isAdd);
					}
				}				
			}
		}
	}
	
	/**
	 * verifie si pBuilding peut recevoir un buff
	 * @param	pBuilding : Building
	 * @return true si il peut
	 */
	private function isBuildingCanBeBuff(pBuilding:Building):Bool
	{
		if (Std.is(pBuilding, BuildingEnergyProducer)|| Std.is(pBuilding, DrillingCenter) || Std.is(pBuilding, DrillingAutoOutPost)) return true;
		else return false;
	}

	override public function applyHoverFilter():Void 
	{
		super.applyHoverFilter();
		if (alienBuffers.length > 0 && buffAera == null) showBuffAera();
	}
	
	override public function removeHoverFilter():Void 
	{
		super.removeHoverFilter();
		if (buffAera != null) 
		{
			buffAera.clear();
			GameStage.getInstance().getGameContainer().removeChild(buffAera);
			buffAera = null;
		}
		
	}
	
	/**
	 * crée graphiquement la zone de buff
	 */
	private function initBuffAeraGraph():Void 
	{
		buffAera = new Graphics();
		buffAera.alpha = 0.2;	
		buffAera.clear();
		buffAera.beginFill(0xccff99);
		
		var lStart:Point = IsoManager.isoViewToModel(position);
		var lIsoTop:Point = IsoManager.modelToIsoView(new Point(lStart.x - buffAeraSize, lStart.y - buffAeraSize));
		var lIsoRight:Point = IsoManager.modelToIsoView(new Point(lStart.x + localWidth  + buffAeraSize, lStart.y - buffAeraSize));
		var lIsoBottom:Point = IsoManager.modelToIsoView(new Point(lStart.x + localWidth + buffAeraSize, lStart.y + localHeight + buffAeraSize));
		var lIsoLeft:Point = IsoManager.modelToIsoView(new Point(lStart.x - buffAeraSize, lStart.y + localHeight + buffAeraSize));
		buffAera.drawPolygon
		([
			lIsoTop.x, lIsoTop.y,
			lIsoRight.x, lIsoRight.y,
			lIsoBottom.x, lIsoBottom.y,
			lIsoLeft.x, lIsoLeft.y
        ]);	
		
		buffAera.endFill();		
	}
	private function showBuffAera():Void 
	{
		if (buffAera == null) initBuffAeraGraph();
		if (buffAera != null) GameStage.getInstance().getGameContainer().addChild(buffAera);
	}
	
	override public function dispose():Void 
	{
		if (prodContainer != null) 
		{
           if (isFilled) prodContainer.off(MouseEventType.CLICK, onCollect);
		   else prodContainer.off(MouseEventType.CLICK, onSkipCooldown);
		   prodContainer.destroyTimer();
		}
		
		for (alien in alienProds) {
		
			alien.dispose();
		}
		
		for (alien in alienBuffers) {
		
			alien.dispose();
		}
		super.dispose();
	}
}