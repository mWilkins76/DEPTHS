package com.isartdigital.ruby.game.world;
import com.isartdigital.ruby.game.sprites.elements.destructible.Destructible;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.UrbanAntenna;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.UrbanPowerStation;
import com.isartdigital.ruby.ui.UIManager;
import com.isartdigital.ruby.ui.popin.buyRegion.BuyRegion;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.iso.IsoManager;
import com.isartdigital.utils.save.DataBaseAction;
import com.isartdigital.utils.save.ElementSave;
import com.isartdigital.utils.save.LayerSave;
import pixi.core.display.DisplayObject;
import pixi.core.graphics.Graphics;
import pixi.core.math.Point;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pixi.filters.color.ColorMatrixFilter;

/**
 * Classe de référence pour une région, permet de la débloquer, de connaître les batiments et aliens qui s'y trouve, et d'ordonner tout graphiquement selon la profondeur.
 * @author Michael Wilkins
 */
class Region
{
	//position et dimension
	public var position:Point;
	public static inline var WIDTH:Int =26;
	public static inline var HEIGHT:Int = 26;
	public var x:Int;
	public var y:Int;

	//public static var regionContainerArray:Array<RegionContainer> = [];

	//filtre
	private var smoke:ColorMatrixFilter;

	//container et background
	public var regionContainer:RegionContainer;
	public var background:Background;
	public var warFog:Background;

	//liste des layer
	public var layers:Array<Layer>;
	private var numberLayer:UInt;

	//la région est elle débloqué
	public var isActive(default, null):Bool = false;
	public var unlockPopin:BuyRegion;
	public var powerStationsInRegion:Array<UrbanPowerStation>;
	public var antennasInRegion:Array<UrbanAntenna>;

	public function new(pX:Int, pY:Int)
	{
		numberLayer = 2;
		x = pX;
		y = pY;
		background = new Background();
		warFog = new Background("WarFog");
		background.start();	
		warFog.start();	
		layers = new Array<Layer>();
		powerStationsInRegion = new Array<UrbanPowerStation>();
		antennasInRegion = new Array<UrbanAntenna>();
		regionContainer = new RegionContainer(x, y);
		regionContainer.addChild(warFog);
		regionContainer.addChild(background);
		
		regionContainer.name = Std.string(x) + " " +Std.string(y);
		background.localHeight = HEIGHT;
		background.localWidth = WIDTH;
		background.currentRegionCoor = new Point(x, y);
		background.visible = false;
		

	}
	
	/**
	 * rend une région active, pour pouvoir poser des batiments dessus
	 */
	public function setActive()
	{
		if (isActive)return;
		isActive = true;
		
		regionContainer.removeChild(warFog);
		warFog.destroy();
		background.visible = true;
		//background.alpha = .5;
	}

	/**
	 * crée un container de region en fonction de la taille des region
	 * et de la taille d'une tile
	 */
	/*private function createRegionContainer(pLayer:Layer):Void
	{
		pLayer.container = new RegionContainer(x, y);
		pLayer.container.position = setPosition(x, y);
		GameStage.getInstance().getGameContainer().addChild(pLayer.container);
		pLayer.container.name = Std.string(x) + " " +Std.string(y);

	}*/

	private function createLayerContainer(pLayer:Layer):Void
	{
		//var lLayerContainer:LayerContainer = new LayerContainer();
		pLayer.container = new RegionContainer(x,y);
		//pLayer.container.addChild(pLayer.container);
		pLayer.container.name = "region" + x + "" + y;
		regionContainer.addChild(pLayer.container);
		//pLayer.container.position = setPosition(x, y);
	}

	/**
	 * modeleToIso pour les regions
	 * @param	pX : position x en modele de la region
	 * @param	pY : position y en modele de la region
	 * @return position de la region en coordonnées global
	 */
	private function setPosition(pX:Float, pY:Float) : Point
	{
		var lHalfWidth:Float = (WIDTH * GameManager.TILE_WIDTH / 2);
		var lHalfHeight:Float = (HEIGHT * GameManager.TILE_HEIGHT / 2);
		var lX:Float = (pX - pY) * lHalfWidth;
		var lY:Float = (pX + pY) * lHalfHeight;
		var lPoint = new Point(lX, lY);
		return lPoint;
	}
	
	



	/**
	 * initialise tout les layers contenu dans la région
	 */
	public function newInitLayer():Void
	{
		for (i in 0...numberLayer)
		{
			var lCurrentLayer:Layer;
			lCurrentLayer = new Layer(WIDTH, HEIGHT);
			layers[i] = lCurrentLayer;
			lCurrentLayer.init();
			createLayerContainer(lCurrentLayer);

		}

		

		GameStage.getInstance().getGameContainer().addChild(regionContainer);
		regionContainer.position = setPosition(x, y);
		
		if (!isActive)
		{
			
			unlockPopin = new BuyRegion();

			UIManager.getInstance().openRegionPopin(unlockPopin);
			unlockPopin.target = background;
			unlockPopin.setOwnRegion(this);
		}
		

	}

	/**
	 * débloque la region
	 */
	public function unlock():Void
	{
		
		World.getInstance().unlockRegion(x, y);
		for (popin in UIManager.getInstance().regionPopins) cast(popin, BuyRegion).displayCost();
		DataBaseAction.getInstance().unlockRegion(x, y);

		Destructible.createDestructibles(this);
		sortAllContainer();
	}

	public function getData():Array<LayerSave>
	{
		if (layers.length <= 0) return null;

		var arrayToSave:Array<LayerSave> = [];

		for (i in 0...layers.length)
		{
			var lIndex:Int = i;
			var lLayerArray:Array<ElementSave> = layers[i].getData();
			var lLayerToSave:LayerSave;

			lLayerToSave =
			{
				index : i,
				grid : lLayerArray
			};

			arrayToSave.push(lLayerToSave);
		}

		return arrayToSave;

	}

	
	public static function sortContainers():Void
	{
		GameStage.getInstance().getGameContainer().children = IsoManager.sortTiles(GameStage.getInstance().getGameContainer().children);
	}

	/**
	 * trie tout les elements contenu dans le GameContainer, puis les elements a l'interieur des enfants du GameContainer
	 */
	public static function sortAllContainer():Void
	{
		var lArray:Array<DisplayObject> = [];
		var lLength:Int = GameStage.getInstance().getGameContainer().children.length;
		for (i in 0 ... lLength)
		{
			var lTemp:DisplayObject = GameStage.getInstance().getGameContainer().children[i];
			
			if (lTemp.name != UnlockButtonContainer.getInstance().name)
			{
				lArray.push(lTemp);
			}
		}
		GameStage.getInstance().getGameContainer().children = IsoManager.sortTiles(lArray);
		
		GameStage.getInstance().getGameContainer().addChild(UnlockButtonContainer.getInstance().getUnlockContainer());
		//UnlockButtonContainer.getInstance().positionning();
		
		//GameStage.getInstance().getGameContainer().addChild(

		for (firstKey in World.getInstance().worldMap.keys())
		{
			for (secondKey in World.getInstance().worldMap.get(firstKey).keys())
			{
				for (i in 0...World.getInstance().worldMap.get(firstKey).get(secondKey).layers.length)
				{
					World.getInstance().worldMap.get(firstKey).get(secondKey).layers[i].container.children = IsoManager.sortTiles(World.getInstance().worldMap.get(firstKey).get(secondKey).layers[i].container.children);
				}
			}
		}
	}

}