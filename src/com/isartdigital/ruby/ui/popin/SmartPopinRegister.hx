package com.isartdigital.ruby.ui.popin;

import com.isartdigital.ruby.ui.ftue.FTUEManager;
import com.isartdigital.ruby.ui.items.switchItems.SwitchItem;
import com.isartdigital.utils.ui.smart.SmartComponent;
import eventemitter3.EventEmitter;
import js.Lib;

import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartPopin;

/**
 * ...
 * @author qPk
 */
class SmartPopinRegister extends SmartPopin
{
	public static var event:EventEmitter = new EventEmitter();
	private static inline var ON_OPEN:String = "onOpen";
	private static inline var ON_YES:String = "onYes";
	public function new(pID:String=null) 
	{
		super(pID);
		name = componentName;
		//event = new EventEmitter();
		ftueRegister();
	}
	
	override public function open():Void 
	{
		super.open();
		event.emit(ON_OPEN);
	}
	
	public function ftueRegister():Void 
	{
		if (children.length <= 0) return;
		for (i in 0...children.length) 
		{
			if (Std.is(children[i], SmartButton)) FTUEManager.register(children[i]);
			else if (Std.is(children[i], SmartComponent)) FTUEManager.register(children[i]);
			else 
			{
				if (Std.is(children[i], SmartComponent)) 
				{
					var component:SmartComponent = cast(children[i], SmartComponent);
					if (component.children.length <= 0) return;
					for (j in 0...component.children.length) 
					{
						if (Std.is(component.children[j], SmartButton)) FTUEManager.register(component.children[j]);
					}
				}
			}
		}
	}

	override public function close():Void 
	{
		super.close();
		
		//SwitchItem.destroyAll();
	}
}