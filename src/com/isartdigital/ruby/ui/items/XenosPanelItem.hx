package com.isartdigital.ruby.ui.items;
import com.isartdigital.ruby.game.sprites.elements.aliens.AlienElement;
import com.isartdigital.ruby.game.world.MapInteractor;
import com.isartdigital.ruby.ui.popin.XenosPanel;

/**
 * ...
 * @author Jordan Dachicourt
 */
class XenosPanelItem extends Item
{

	private var alien:AlienElement;
	
	public function new(pID:String=null) 
	{
		super(pID);
		init();
		
	}
	
	
	
	public function setInfo(pAlienElem:AlienElement) 
	{
		alien = pAlienElem;
		interactive = true;
		//image
		//setNormal();
		
	}
	
	override function onClick():Void 
	{
		super.onClick();
		
		XenosPanel.getInstance().alienSelected = alien;
		MapInteractor.getInstance().alienSelected = alien;
		XenosPanel.getInstance().appearContextualMenuItemAt(x  - width * 4);
		XenosPanel.getInstance().onMove();
		
		
	}
}