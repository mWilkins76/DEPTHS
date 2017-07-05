package com.isartdigital.ruby.game.sprites.elements.urbanbuilding.translationClass;

/**
 * ...
 * @author Julien Fournier
 */

typedef Schemas = {
	var idPlayer:Int;
	var idSchema:Int;
	var isLocked:Int;
	var startDecrypt:Date;
	@:optional var endDecrypt:Date;
	@:optional var decryptTime:String;
}