package com.isartdigital.ruby.ui.popin.shop.datas;
enum Gain { SoftCurrency; HardCurrency; GeneBeta; GeneIota; GeneRho; GeneSigma; GeneUpsilon; DarkMatter; BluePrint; }
/**
 * @author Jordan Dachicourt
 */
typedef GainParams =
{
	var quantity:Int;
	var type:Gain;	
}