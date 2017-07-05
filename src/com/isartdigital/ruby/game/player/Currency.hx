package com.isartdigital.ruby.game.player;

/**
 * ...
 * @author Jordan Dachicourt
 */
class Currency
{

	private var quantity:Float;
	
	private function new() {
		
	}
	
	public function hasEnough(pQuantity:Float):Bool{
		return quantity >= pQuanity;
	}
	
	public function add(pQuantity:Float):Void{
		quantity+=pQuan
	}
	
	public function substract(pQuantity:Float):Bool{
		if (hasEnough(pQuantity)) return false;
		
		quantity -= pQuantity;
		return true;	
	}
	
}