package com.isartdigital.ruby.game.specialFeature.managers;
import com.isartdigital.ruby.game.specialFeature.managers.SpecialFeatureAliens;
import com.isartdigital.ruby.game.sprites.elements.ElementType;
import com.isartdigital.ruby.utils.ColorFilterManager;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.sounds.SoundManager;

	
/**
 * ...
 * @author Julien Fournier
 */
class SFEventsManager 
{
	public static inline var MODE_MOVE:String = "Move";
	public static inline var MODE_SKILL:String = "Skill";
	private var oldAlien:SpecialFeatureAliens;
	
	
	/**
	 * instance unique de la classe SpecialFeatureManagerEvents
	 */
	private static var instance: SFEventsManager;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): SFEventsManager {
		if (instance == null) instance = new SFEventsManager();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		
	}

	/**
	 * Fonction Callback qui gère les events de selection d'aliens par le Hud 
	 * @param	pAlienIndex
	 * @param	pMode
	 */
	public function selectAlienOnHud(pAlienIndex:Int, pMode:String):Void
	{
		
		if (SFAliensManager.getInstance().selectedAlien != null)
		{			
			SFGameManager.getInstance().tileContainer.off(MouseEventType.CLICK,SFAliensEventManager.getInstance().actions);
			SFGameManager.getInstance().tileContainer.off(TouchEventType.TAP,SFAliensEventManager.getInstance().actions);
		}
		
		if (oldAlien != null)
		{
			oldAlien.changeAssetName(oldAlien.alienType+Std.string(oldAlien.alienID));
			oldAlien.changeAsset("Normal");
		}
		
		SFAliensManager.getInstance().selectedAlien = SFAliensManager.getInstance().activatedAlienList[pAlienIndex];
		
		if (SFAliensManager.getInstance().selectedAlien.alienType == ElementType.ALIEN_BOMBER) SoundManager.getSound("soundPlayerChooseXenosBomber").play();					
		if (SFAliensManager.getInstance().selectedAlien.alienType  == ElementType.ALIEN_DRILLER) SoundManager.getSound("soundPlayerChooseXenosForeur").play();					
		if (SFAliensManager.getInstance().selectedAlien.alienType  == ElementType.ALIEN_HEALER) SoundManager.getSound("soundPlayerChooseXenosHealer").play();					
		if (SFAliensManager.getInstance().selectedAlien.alienType  == ElementType.ALIEN_TANK) SoundManager.getSound("soundPlayerChooseXenosTank").play();					
		
		
		oldAlien = SFAliensManager.getInstance().selectedAlien;
		SFAliensManager.getInstance().selectedAlien.changeAssetName(SFAliensManager.getInstance().selectedAlien.alienType+Std.string(SFAliensManager.getInstance().selectedAlien.alienID));
		SFAliensManager.getInstance().selectedAlien.changeAsset("Selected");
		
		if (SFAliensManager.getInstance().selectedAlien != null)
		{
			if (pMode == MODE_MOVE) SFAliensEventManager.getInstance().setModeMove();
			if (pMode == MODE_SKILL) SFAliensEventManager.getInstance().setModeSkill();
			SFGameManager.getInstance().tileContainer.on(MouseEventType.CLICK,SFAliensEventManager.getInstance().actions);
			SFGameManager.getInstance().tileContainer.on(TouchEventType.TAP, SFAliensEventManager.getInstance().actions);			
		
		}
		else{		
			SFGameManager.getInstance().tileContainer.off(MouseEventType.CLICK,SFAliensEventManager.getInstance().actions);
			SFGameManager.getInstance().tileContainer.off(TouchEventType.TAP,SFAliensEventManager.getInstance().actions);
		}
		
		var params:ColorFilterParams =
		{
			colorToApply:"orange",
			colorAmount:1,
			duration:1
		}
		ColorFilterManager.getInstance().applyFilter(SFAliensManager.getInstance().selectedAlien, params);
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}