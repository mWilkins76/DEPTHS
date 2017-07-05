package com.isartdigital.ruby.game.specialFeature.managers;
import cloudkid.Emitter;
import com.greensock.TweenMax;
import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.game.specialFeature.managers.SpecialFeatureAliens;
import com.isartdigital.ruby.game.specialFeature.managers.SFGridManager.Vector3;
import com.isartdigital.ruby.game.specialFeature.tiles.Tile;
import com.isartdigital.ruby.game.sprites.elements.ElementType;
import com.isartdigital.ruby.utils.ParticleManager;
import com.isartdigital.ruby.utils.RessourcesEffectManager;
import com.isartdigital.ruby.utils.RessourcesEffectManager.RessourcesEffectParams;
import com.isartdigital.ruby.utils.SmartShaker;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.sounds.SoundManager;
import haxe.Json;
import pixi.core.display.Container;
import pixi.core.math.Point;

/**
 * ...
 * @author Julien Fournier
 */
class SFAliensEventManager
{
	public var currentMode:String = "";
	public var delay:Float = 0;

	/**
	 * instance unique de la classe SpecialFeatureManager
	 */
	private static var instance: SFAliensEventManager;
	
	private function new() 
	{
		
	}
	
	/**
	 * Check le current mode (Move,Skill) et lance les bonnes actions
	 */
	public function actions():Void
	{
		var lAlien :SpecialFeatureAliens = SFAliensManager.getInstance().selectedAlien;
		SFGridManager.getInstance().globalMousePos = SFGridManager.getInstance().getGlobalMouseCoords(SFGameManager.getInstance().ressourcesContainer);
		SFGridManager.getInstance().gridMousePos = SFGridManager.getInstance().getGridCoords(SFGridManager.getInstance().globalMousePos);

		
		if (SFAliensManager.getInstance().selectedAlien != null)
		{	
			var lAlienPos:Point = SFGridManager.getInstance().getGridCoords(lAlien.position);

			if (currentMode == SFEventsManager.MODE_MOVE)
			{
				if (SFGridManager.getInstance().checkWallinNextPos(lAlienPos, SFGridManager.getInstance().gridMousePos)) return;
				if (canMove(SFGridManager.getInstance().gridMousePos)) move();
				else dig(SFGridManager.getInstance().gridMousePos);					
			}
			else if (currentMode == SFEventsManager.MODE_SKILL)
			{
				if (SFAliensManager.getInstance().selectedAlien.alienType == ElementType.ALIEN_BOMBER)
				{
					
					canBomb(SFGridManager.getInstance().gridMousePos);
				}
				if (SFAliensManager.getInstance().selectedAlien.alienType == ElementType.ALIEN_HEALER)
				{
					canHeal(SFGridManager.getInstance().gridMousePos);
				}
			}
		}
	}
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): SFAliensEventManager {
		if (instance == null) instance = new SFAliensEventManager();
		return instance;
	}
		/**
	 * Lance le mode move, active le mode propagation du mouvement d'un alien
	 */
	public function setModeMove():Void
	{
		currentMode = SFEventsManager.MODE_MOVE;
		var lAlien:SpecialFeatureAliens = SFAliensManager.getInstance().selectedAlien;
		var lVector3Array:Array<Vector3>;
		var lAction:String;	
		
		lVector3Array =	SFGridManager.getInstance().getPropagationPath(lAlien.alienType, lAlien.positionInGrid, lAlien.stamina);

		SFTilesManager.getInstance().removeSpecialTile();
		for (vector in lVector3Array) 
		{
			lAction = (lAlien.stamina - vector.z) == 1 ? "dig":"move";
			SFTilesManager.getInstance().addSpecialTile(lAction, new Point(vector.x*SFGridManager.CELL_WIDTH ,vector.y*SFGridManager.CELL_HEIGHT));
		}
	}
	
	
	/**
	 * Lance le mode skill, active le mode propagation du skill d'un alien
	 */
	public function setModeSkill():Void
	{
		currentMode = SFEventsManager.MODE_SKILL;
		var lAlien:SpecialFeatureAliens = SFAliensManager.getInstance().selectedAlien;
		
		if (lAlien.alienType == ElementType.ALIEN_TANK
		|| lAlien.alienType == ElementType.ALIEN_DRILLER
		|| (lAlien.alienType == ElementType.ALIEN_BOMBER && lAlien.bombNumber == 0)
		|| (lAlien.alienType == ElementType.ALIEN_HEALER && lAlien.stamina == 0))
		{
			setModeMove();
			return;
		}

		var lAlienPos:Point = SFGridManager.getInstance().getGridCoords(lAlien.position);

		var lTile:Tile;
		var lSkillTile:Tile;
		var distance:Int;
		var counter:Int=0;
		
		SFTilesManager.getInstance().removeSpecialTile();
		var length:Int = SFTilesManager.getInstance().tileList.length;
		var tilePos:Point;
		
		for (j in 0...SFGridManager.COLS) 
		{
			for (k in 0...SFGridManager.ROWS) 
			{
				tilePos = new Point(j, k);
				distance = Math.floor(Math.abs(lAlienPos.x - tilePos.x) + Math.abs(lAlienPos.y - tilePos.y));

				if (distance <= lAlien.powerRange)
				{
					SFTilesManager.getInstance().addSpecialTile("skill", SFGridManager.getInstance().getGlobalGridCoords(tilePos));
				}
			}			
		}
	}
	
	
	
		/**
	 * Bouge l'alien au clic/tap
	 */
	private function move():Void
	{
		var gridMousePos:Point = SFGridManager.getInstance().gridMousePos;
		delay = 0;
		moveAtCoord(gridMousePos);
	}
	

	
	public function moveAtCoord(pTarget:Point):Void
	{
		//déplace l'alien à la position du clic mais dans le modèle de la grille
		var lAlien:SpecialFeatureAliens = SFAliensManager.getInstance().selectedAlien;
		var newPos:Point = SFGridManager.getInstance().getGlobalGridCoords(SFGridManager.getInstance().getGridCoords(SFGridManager.getInstance().globalMousePos));
		var jsonList:Array<Dynamic> = SFGridManager.getInstance().jsonGrid[Math.floor(pTarget.x)][Math.floor(pTarget.y)];

		if (jsonList != null)
		{			
			//parcour chaque object dans la case cliquée
			for (object in 0...jsonList.length) 
			{		
				if (jsonList[object].type.substring(0, 4) == ElementType.ITEM && SFAliensManager.getInstance().isAlienNextToTile(pTarget))
				{
					rewardAnimation(jsonList[object], pTarget);
				}
			}
		}
		var lDelay:Float = currentMode == "dig" ? 0.2:0; 
		//lAlien.position = newPos;
		setModeMove();
		trace(delay);
		TweenMax.to(lAlien, 0.2 , {x:newPos.x, y:newPos.y,delay:delay});
		SpecialFeatureScreen.getInstance().updateAlienHud();
	}
	
	private function rewardAnimation(pRessource:Dynamic, pTarget:Point):Void
	{
		var effectParams:RessourcesEffectParams =
		{
			originalPosition:SFGridManager.getInstance().getGlobalGridCoords(pTarget),
			destinationPosition:SFGameManager.getInstance().rewardContainer.toLocal(SpecialFeatureScreen.getInstance().getRessourceHudPosition(pRessource.type)),
			whereToAddchild:SFGameManager.getInstance().rewardContainer,
			numObjectsToInstanciate:20,
			duration:1,
			secondsBtwnaddchilds:1,
			speed:0.2,
			animationType:"dispersionToCurve",
			ressource:pRessource.type,
		}
		
		RessourcesEffectManager.getInstance().SetEffect(effectParams);
		
		var lParticle:Container = ParticleManager.getInstance().createParticle("bubble", ["bubble"], 5000);
		lParticle.position = SFGridManager.getInstance().getGlobalGridCoords(pTarget);
		SFGameManager.getInstance().particleContainer.addChild(lParticle);

		
		SFGameManager.getInstance().giveRewardToPlayer(pRessource.type);
		SFTilesManager.getInstance().removeInTileList(pRessource);
	}
	

	
		
	/**
	 * creuse une tile
	 * @param	pMousePos
	 */
	private function dig(pMousePos:Point):Void
	{
		var jsonList:Array<Dynamic> = SFGridManager.getInstance().jsonGrid[Math.floor(pMousePos.x)][Math.floor(pMousePos.y)];
		var lAlien:SpecialFeatureAliens = SFAliensManager.getInstance().selectedAlien;

		if (!SFAliensManager.getInstance().hasEnoughStamina()) return;
		
		if (jsonList != null)
		{			
			//parcour chaque object dans la case cliquée
			for (object in 0...jsonList.length) 
			{	
				// si l'object est un bloc
				if (jsonList[object].type.substring(0, 4) == ElementType.CLUE)
				{
					if(SFAliensManager.getInstance().isAlienNextToTile(pMousePos)) // si l'alien est à une case à côté du bloc
					{
						
						var lParticle:Container = ParticleManager.getInstance().createParticle("dig", ["bloc1","bloc2","bloc3","bloc4","smoke4"], 5000);
						lParticle.position = SFGridManager.getInstance().getGlobalGridCoords(pMousePos);
						SFGameManager.getInstance().particleContainer.addChild(lParticle);
						
						var params:ShakerParams =
						{
							originalPosition: SpecialFeatureScreen.getInstance().position.clone(),
							smoothness:3,
							amplitude:10,
							duration:30,
							xQuantity: 0.5,
							yQuantity: 0.5,
							fadeOut: 1,
							randomShake: true,
							sound:null				
						}

						SmartShaker.getInstance().SetShaker(SpecialFeatureScreen.getInstance(), params);
						SoundManager.getSound("soundXenosDrillShort").play();
							
						SFTilesManager.getInstance().removeInTileList(jsonList[object]);
						SFAliensManager.getInstance().decreaseStamina(lAlien);
						delay = 0.1;
						moveAtCoord(pMousePos);
					}
				}

			}
		}
		SpecialFeatureScreen.getInstance().updateAlienHud();
	}
	

	
	/**
	 * Vérifie si le joueur peut se déplacer
	 * @param	pMousePos
	 * @return
	 */
	private function canMove(pMousePos:Point):Bool
	{
		var jsonList:Array<Dynamic> = SFGridManager.getInstance().jsonGrid[Math.round(pMousePos.x)][Math.round(pMousePos.y)];
		var lAlien:SpecialFeatureAliens = SFAliensManager.getInstance().selectedAlien;

		if (!SFAliensManager.getInstance().isAlienNextToTile(pMousePos)) return false;

		if (jsonList != null)
		{
			for (object in 0...jsonList.length) 
			{

				if(jsonList[object].type.substring(0, 4) == ElementType.LAVA && lAlien.alienType != ElementType.ALIEN_TANK)
				{
				   return false;
				}
				if (jsonList[object].type.substring(0, 4) == ElementType.LAVA && lAlien.alienType == ElementType.ALIEN_TANK)
				{
					SoundManager.getSound("soundTankWalkLava").play();
				}
				
				if (jsonList[object].type.substring(0, 4) == ElementType.CLUE|| jsonList[object].type.substring(0, 9) == ElementType.HARDBRICK)
				{
					return false;
				}
			}			
		}
		return true;
	}
	
	/**
	 * Vérifie si le Bomber peut bombarder une zone en fonction de sa stamina disponible
	 * @param	pTarget
	 * @return
	 */
	private function canBomb(pTarget:Point):Bool
	{
		var jsonList:Array<Dynamic> = SFGridManager.getInstance().jsonGrid[Math.floor(pTarget.x)][Math.floor(pTarget.y)];
		var lAlien:SpecialFeatureAliens = SFAliensManager.getInstance().selectedAlien;

		if (lAlien.bombNumber <=0) return false;
		
		if (jsonList != null)
		{	

			
			for (object in 0...jsonList.length) 
			{	
				if (jsonList[object].type.substring(0, 4) == ElementType.ITEM)
				{
					rewardAnimation(jsonList[object], pTarget);
				}
				
				if (SFTilesManager.getInstance().isTileInRange(pTarget) &&
				(jsonList[object].type.substring(0, 4) == ElementType.CLUE ||
				jsonList[object].type.substring(0, 9) == ElementType.HARDBRICK))
				{

					var params:ShakerParams =
					{
						originalPosition: SpecialFeatureScreen.getInstance().position.clone(),
						smoothness:7,
						amplitude:15,
						duration:30,
						xQuantity: 0.5,
						yQuantity: 0.5,
						fadeOut: 1,
						randomShake: true,
						sound:null				
					}

					SmartShaker.getInstance().SetShaker(SpecialFeatureScreen.getInstance(), params);	

					SoundManager.getSound("soundXenosBomberPower").play();

					var lParticle:Container = ParticleManager.getInstance().createParticle("dig", ["bloc1","bloc2","bloc3","bloc4","smoke4"], 5000);
					lParticle.position = SFGridManager.getInstance().getGlobalGridCoords(pTarget);
					SFGameManager.getInstance().particleContainer.addChild(lParticle);
					
					var lParticle2:Container = ParticleManager.getInstance().createParticle("bomb", ["bloc1","bloc2","bloc3","bloc4","smoke4"], 5000);
					lParticle2.position = SFGridManager.getInstance().getGlobalGridCoords(pTarget);
					SFGameManager.getInstance().particleContainer.addChild(lParticle2);
					
					SFTilesManager.getInstance().removeInTileList(jsonList[object]);
					jsonList[object].type = "destroyed";
					lAlien.bombNumber--;
					setModeSkill();
					return true;
				}
			}
		}
		return false;
	}
			

	/**
	 * Vérifie si le Healer peut donner de la stamina à tous les aliens d'une zone une zone en fonction de sa stamina disponible
	 * @param	pTarget
	 * @return
	 */
	private function canHeal(pTarget:Point):Bool
	{
		var result:Bool = false;
		var lPos:Point;
		var lAlien:SpecialFeatureAliens = SFAliensManager.getInstance().selectedAlien;

		if (lAlien.stamina > 0)
		{
			for (alien in SFAliensManager.getInstance().activatedAlienList) 
			{
				lPos = SFGridManager.getInstance().getGridCoords(alien.position);
				if (lPos.x == pTarget.x && lPos.y == pTarget.y)
				{
					SFAliensManager.getInstance().increaseStamina(1, alien);
					SpecialFeatureScreen.getInstance().updateAlienHud();
					result = true;
				}
				
			}
			if (result)
			{
				SFAliensManager.getInstance().decreaseStamina(lAlien);
				SpecialFeatureScreen.getInstance().updateAlienHud();
				SoundManager.getSound("soundXenosHealerPower").play();
				return true;
			}
			else return false;
		}
		else
		{
			setModeMove();
			return false;
		}

	}	
	
		/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
		
		//suppression de l'écouteur de clic
	}
}