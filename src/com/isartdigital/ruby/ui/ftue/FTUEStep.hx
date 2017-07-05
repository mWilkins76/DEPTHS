package com.isartdigital.ruby.ui.ftue;

import pixi.core.display.DisplayObject;

/**
 * @author Mathieu Anthoine
 */
typedef FTUEStep = {
	var name:String;
	var parentName:String;
	var grandParentName:String;
	var arGrandParentName:String;
	var checkpoint:Bool;
	var arrowRot:Int;
	var arrowTarget:String;
	var ftueStop:Bool;
	var event:String;
	var text:String;
	var textPos:String;
	var gift:String;
	var isAction:Bool;
	@optional var emotion:String;
	@optional var arrowRecule:Int;
	@optional var item:DisplayObject;
	@optional var itemTarget:DisplayObject;
}