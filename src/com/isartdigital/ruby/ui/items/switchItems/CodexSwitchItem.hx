package com.isartdigital.ruby.ui.items.switchItems;
import com.isartdigital.ruby.game.sprites.elements.aliens.Alien;
import com.isartdigital.ruby.ui.popin.codex.XenoCodexTypedef;
import com.isartdigital.ruby.ui.popin.XenoPage;
import com.isartdigital.utils.ui.smart.TextSprite;
import js.Lib;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author Jordan Dachicourt
 */
class CodexSwitchItem extends SwitchItem
{

	static inline var NAME:String = "txt_XenoName";
	static inline var QUANTITY:String = "txt_QuantityUnitDisplay";
	static inline var PREFIX:String = "XenosThumbnail_";

	private var textName:TextSprite;
	private var textQuantity:TextSprite;

	private var currentAlien:XenoCodexTypedef;

	private var quantity:Int;

	private var firsTime:Bool = false;

	public function new(pID:String=null)
	{
		super(pID);

	}

	override public function init()
	{
		super.init();
		textName = cast(getChildByName(NAME), TextSprite);
		textQuantity = cast(getChildByName(QUANTITY), TextSprite);
		prefix = PREFIX;
		addStateSuffix = true;
	}

	public function setInfo(pAlien:XenoCodexTypedef)
	{
		if (!firsTime)
		{

			currentAlien = pAlien;
			assetName = currentAlien.name;
			textName.text =  (currentAlien.nomenclature != "" ? currentAlien.nomenclature : currentAlien.name);
			quantity = currentAlien.quantity;
			textQuantity.text =  quantity + "";
			if (quantity == 0)
				setDisabled();
			else
				setNormal();

			setAsset();
			firsTime = true;
		}
	}

	override function onOver():Void
	{
		super.onOver();
		setAsset();
	}

	override function onOut():Void
	{
		super.onOver();
		setAsset();
	}

	override function monClick():Void
	{
		super.monClick();
		if (currentState.name != "Disabled")
		{

			setAsset();
			UIManager.getInstance().openPopin(XenoPage.getInstance());

			XenoPage.getInstance().setAlienInfoToDisplay(currentAlien);
		}
		//Alien.alienList.
	}

	override function onDown():Void
	{
		super.onDown();
		setAsset();
	}

}