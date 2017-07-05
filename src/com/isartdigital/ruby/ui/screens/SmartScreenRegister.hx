package com.isartdigital.ruby.ui.screens;

import com.isartdigital.ruby.ui.ftue.FTUEManager;
import com.isartdigital.ruby.ui.items.switchItems.SwitchItem;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartScreen;

/**
 * ...
 * @author qPk
 */
class SmartScreenRegister extends SmartScreen
{

	public function new(pID:String=null) 
	{
		super(pID);
		name = componentName;
		ftueRegister();
	}
	
	public function ftueRegister():Void 
	{
		for (i in 0...children.length) 
		{
			if (Std.is(children[i], SmartButton)) FTUEManager.register(children[i]);
			else if(Std.is(children[i], SmartComponent)) FTUEManager.register(children[i]);
		}
	}
	
	override public function close():Void 
	{
		super.close();
		
		//SwitchItem.destroyAll();
	}
}