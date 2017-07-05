package com.isartdigital.ruby.ui.items.switchItems;
import com.isartdigital.ruby.ui.popin.codex.Codex;

/**
 * ...
 * @author Jordan Dachicourt
 */
class CodexSwitchTab extends SwitchGroupItem
{

	public function new(pID:String=null) 
	{
		super(pID);
	}
	
	override public function init() 
	{
		super.init();
		prefix = "Codex_TabAsset_";
		switch(id) {
			case 0:
				assetName = "All";
			case 1:
				assetName = "Buffeur";
			case 2:
				assetName = "Esthetique";
			case 3:
				assetName = "Foreur";	
			default:
				assetName = "All";
		}
	}
	override function monClick():Void 
	{
		super.monClick();
		
		switch(id) {
			case 0:
				Codex.getInstance().updateItems();
			case 1:
				Codex.getInstance().updateItemsByTypes("AlienBuffer", "AlienProducer");
			case 2:
				Codex.getInstance().updateItemsByTypes("AlienEsthetique");
			case 3:
				Codex.getInstance().updateItemsByTypes("AlienForeur");
			default:
				Codex.getInstance().updateItems();
		}
	}
	
	
}