package com.isartdigital.ruby.game.sprites.elements.alienbuilding;
import com.isartdigital.utils.game.clipping.IClippable.Element;

/**
 * ...
 * @author Julien Fournier
 */
class AlienResearchCenter extends Building
{

	public function new(pAsset:String=null) 
	{
		
		super(pAsset);
		buildingName = "Reseerch Center";
		description = "Permet d'effectuer des recherches scientifiques pour découvrir des schémas de nouvelles races xenos.";
		localWidth = 4;
		localHeight = 3;
		//setTimeToBuild : secondes/minutes/heures/jours
		//setTimeToBuild(0, 0, 1, 0);
	}
	
	override public function init(?pElem:Element=null):Void 
	{
		super.init(pElem);

		/*

		Insérez ces lignes utile au timerMAnager Quand le joueur pose un batiment
		TimeManager.getInstance().init(this);
		endOfBuildTime = TimeManager.getInstance().getEndOfBuildDate();
		*/
	}
	
}