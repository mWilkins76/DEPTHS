package com.isartdigital.ruby.ui.popin.incubator;

import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.ui.items.switchItems.SwitchGroupItem;
import com.isartdigital.ruby.ui.popin.incubator.Incubator;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;

/**
 * ...
 * @author Guillaume Zegoudia
 */
class GeneButton extends SwitchGroupItem
{
	
	private static inline var TEXT_QUANTITY:String = "txt_geneQuantity";
	public var quantity:Int;
	private var textQuantity:TextSprite;
	private var geneAsset:UISprite;
	public var idGene:Int;
	
	public function new(pID:String=null) 
	{
		super(pID);
		/*Incubator.arrayGeneButton.push(this);
		
		on(MouseEventType.CLICK, changeIncubatorCurrentGeneButton);
		on(TouchEventType.TAP, 	 changeIncubatorCurrentGeneButton);*/
		/*interactive = false;
		buttonMode = false;*/
	}
	
	
	public function initSup():Void
	{
		geneAsset = new UISprite("IncubatorGene" + idGene);
		quantity = Reflect.getProperty(Player.getInstance(), "gene" + idGene);
		currentState.addChild(geneAsset);
	}
	
	public function updateQuantityGene():Void
	{
		quantity = Reflect.getProperty(Player.getInstance(), "gene" + idGene);
	}
	
	private function setInfo() {
		textQuantity = cast(currentState.getChildByName(TEXT_QUANTITY), TextSprite);
		textQuantity.text = Std.string(quantity);
		if (geneAsset == null || currentState == null) return;
 		if (currentState.children.indexOf(geneAsset) == -1) currentState.addChild(geneAsset);

	}
	
	override public function setNormal() 
	{
		super.setNormal();
		setInfo();
	}
	
	override public function setDisabled() 
	{
		super.setDisabled();
		setInfo();
	}
	
	override public function setSelected() 
	{
		//super.setSelected();
		setInfo();
	}
	
	override function monClick():Void 
	{
		/*super.monClick();
		Incubator.getInstance().geneSelected = idGene;
		Incubator.getInstance().quantityMax = quantity;*/
		setInfo();
	}
	
	override function onOver():Void 
	{
		//super.onOver();
		setInfo();
	}	
	
	override function onOut():Void 
	{
		//super.onOut();
		setInfo();
	}
	
	private function changeIncubatorCurrentGeneButton():Void
	{
		
		/*geneNumber = cast(Std.parseInt(this.name.split("").pop()), UInt);
		Incubator.getInstance().currentGeneButton = this;
		Incubator.getInstance().checkSpotAndGene();*/
	}
	
}