package com.isartdigital.ruby.ui.popin.shop.datas;
import com.isartdigital.ruby.ui.popin.shop.datas.GainParams;

enum Money { SoftCurrency; HardCurrency; IsartPoint; }


/**
 * @author Jordan Dachicourt
 */
typedef ShopItemParams =
{
	var name:String;
	var typeMoney:Money;
	var price:Float;
	var gains:Array<GainParams>;
	var promo:Float;
}

