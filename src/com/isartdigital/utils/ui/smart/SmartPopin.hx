package com.isartdigital.utils.ui.smart;

import com.isartdigital.utils.ui.Popin;

/**
 * ...
 * @author Mathieu Anthoine
 */
class SmartPopin extends Popin
{

	public function new(pID:String=null) 
	{
		super(pID);
		buttonMode = true;
		interactive = true;
		defaultCursor = "url(assets/Curseur.png), auto";
		build();
	}
	
}