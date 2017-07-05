package com.isartdigital.ruby.ui;
import com.isartdigital.ruby.game.controller.Controller;
import com.isartdigital.ruby.ui.items.Item;
import com.isartdigital.ruby.ui.items.switchItems.BuildingMenuSwitchItem;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartComponent;
import js.Lib;
import pixi.core.display.DisplayObject;
import pixi.core.graphics.Graphics;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author Jordan Dachicourt
 */
class Slider extends DisplayObject
{
	
	private var g:Graphics;
	
	private var hasEnoughItemToSlide:Bool;
	private var isOver:Bool;
	private var isDown:Bool;
	
	private var oldX:Float;
	private var deltaX:Float;
	private var beginXSlider:Float;
	private var lastItemX:Float;
	private var firstItemX:Float;
	private var endXSlider:Float;
	
	private var mainContainer:SmartComponent;
	public var itemContainer(default, null):SmartComponent;
	
	private var isListeningItem:Bool;
	private var theMask:Graphics;
	private var isParamsUpdate:Bool = false;
	public function new() 
	{
		super();
		g = new Graphics();
	}
	
	/**
	 * Initialisele slider, les containeurs et les écouteurs
	 */
	public function init(pSlider:SmartComponent, pItemContainer:SmartComponent) {
		
		initContainer(pSlider, pItemContainer);
		
	}
	
	private function initMask() {
		if(theMask == null)
			theMask = new Graphics();
		
		theMask.beginFill(0xffffff);
		theMask.drawRect(0-(mainContainer.width-150)/2, itemContainer.y-mainContainer.height/2, mainContainer.width-150, mainContainer.height);
		theMask.endFill();
		mainContainer.addChildAt(theMask, 0);
		
	}
	
	public function initContainer(pSlider:SmartComponent, pItemContainer:SmartComponent) {
		mainContainer = pSlider;
		mainContainer.interactive = true;
		
		itemContainer = pItemContainer;
		itemContainer.interactive = true;
		
		mainContainer.on(MouseEventType.MOUSE_MOVE, onSlide);
		mainContainer.on(MouseEventType.MOUSE_DOWN, function() {
			isDown = true;
			oldX = Controller.getInstance().getPosFrom(mainContainer).x;
		});
		mainContainer.on(MouseEventType.MOUSE_UP, function() {
			isDown = false;			
			checkSliderPosition();
			listenItems();
		});
		mainContainer.on(MouseEventType.MOUSE_OVER, function() {
			isOver = true;
		});
		mainContainer.on(MouseEventType.MOUSE_OUT, function() {
			isDown = false;
			isOver = false;
			listenItems();
		});
		
		
		if (!isParamsUpdate) updateParams();
		
		
		itemContainer.mask = theMask;
	}
	
	public function setItemContainer(pItemContainer:SmartComponent) {
		
	}
	public function update() {
		setItemPositionToBeginPosition();
		updateFirstAndLastXItemData();
		checkIfHasEnoughItemToSlide();
		listenItems();
	}
	/**
	 * met à jour les parametres slider permetant de definir les cran d'arret
	 */
	private function updateParams() {
		beginXSlider = itemContainer.x;
		endXSlider =  mainContainer.width/2 - 200;
		if (theMask == null) initMask();
		isParamsUpdate = true;
	}
	
	private function updateFirstAndLastXItemData() {
		if (itemContainer.children.length <= 0) return;
		lastItemX = itemContainer.x + itemContainer.getChildAt(itemContainer.children.length - 1).x;
		firstItemX = itemContainer.x;
	}
	
	private function setItemPositionToBeginPosition() {
		itemContainer.x = beginXSlider;
	}
	
	private function checkIfHasEnoughItemToSlide() {
		hasEnoughItemToSlide = lastItemX > endXSlider;
	}
	/**
	 * callback d'event ce qui est exectué au mouvement de la souris
	 * @param	pEvent
	 */
	private function onSlide(pEvent:EventTarget) {
		
		if (isDown) {
			moveTheSlider();
			//draw();
		}
	}
	
	/**
	 * Gere le mouvement du slider
	 */
	private function moveTheSlider() {
		if (hasEnoughItemToSlide) {		
			
			var currentX:Float = Controller.getInstance().getPosFrom(mainContainer).x;
			updateFirstAndLastXItemData();
			deltaX = currentX - oldX;
			
			if (Math.abs(deltaX) > 5) offItems();
			
			var newX:Float = itemContainer.x + deltaX;
			
			if(newX <= beginXSlider && lastItemX >= endXSlider)
				itemContainer.x  = newX;
				
			oldX = currentX;
		}
	}
	
	private function listenItems() {
		if (!isListeningItem) {	
			for (item in itemContainer.children) {
				cast(item, Item).onListen();	
			}
			isListeningItem = true;
		}
	}
	
	private function offItems() {
		if (isListeningItem) {
			for (item in itemContainer.children)
				cast(item, Item).onOff();
				
			isListeningItem = false;
		}	
	}
	
	/**
	 * Reposition le slider si la position n'est pas dans le clamp
	 */
	private function checkSliderPosition() {
		if (hasEnoughItemToSlide) {
			if (itemContainer.x > beginXSlider) {	
				itemContainer.x = beginXSlider;
			}
			else if (lastItemX < endXSlider)
				itemContainer.x += endXSlider - lastItemX + 5;
		}
		
	}
	
	private function draw() {
		g.clear();
			
		//ROUGE LE DEPART SLIDER
		g.beginFill(0xff0000);
		g.drawCircle(beginXSlider, 0, 10);
		g.endFill();
		
		//ROSE LE PREMIER ITEM
		g.beginFill(0xff00ff);
		g.drawCircle(firstItemX, 0, 10);
		g.endFill();
		
		//VERT LA FIN DU SLIDER
		g.beginFill(0x00ff00);
		g.drawCircle(endXSlider, 0, 10);
		g.endFill();
		
		//BLEU LE DERNIER ITEM
		g.beginFill(0x0000ff);
		g.drawCircle(lastItemX, 0, 10);
		g.endFill();
		
		mainContainer.addChild(g);
	}
	
}