package com.isartdigital.ruby.ui.popin;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.ui.smart.SmartButton;

/**
 * ...
 * @author Guillaume Zegoudia
 */
class MenuClosable extends SmartPopinRegister
{

	private var close_btn:SmartButton;
	private static inline var CLOSE_BTN:String = "btn_Close";
	public function new(pID:String=null)
	{
		super(pID);

	}

	private function init():Void
	{
		
		close_btn = cast(getChildByName(CLOSE_BTN), SmartButton);
		close_btn.on(MouseEventType.CLICK, onClose);
		close_btn.on(TouchEventType.TAP, onClose);
	}
	
	private function onClose():Void {
		UIManager.getInstance().closePopin(this);
	}

}