package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Octorok extends Creature
	{
		[Embed(source="images/octorok.png")] public static const OctorokGfx: Class;
		[Embed(source="images/octorok-nose.png")] public static const NoseGfx: Class;
		
		public var walkSprite:Spritemap;
		public var noseSprite:Spritemap;
		
		public function Octorok (_x:Number = 0, _y:Number = 0)
		{
			super(_x, _y);
			
			walkSprite = new Spritemap(OctorokGfx, 16, 16);
			noseSprite = new Spritemap(NoseGfx, 16, 16);
			
			graphic = new Graphiclist(walkSprite, noseSprite);
			
			walkSprite.centerOO();
			walkSprite.add("walk", [0, 1], 0.1);
			walkSprite.play("walk");
			
			noseSprite.centerOO();
			noseSprite.add("wobble", [0, 1], 0.05);
			noseSprite.add("spit", [2, 3, 0], 0.125, false);
			noseSprite.play("wobble");
			
			setHitbox(12, 12, 6, 6);
		}
		
		public override function doMovement (): void
		{
			moveBy(dx, dy, "octorok_solid");
			
			if (isMoving) {
				walkSprite.angle = angle;
				noseSprite.angle = angle;
			}
			
			walkSprite.rate = isMoving ? 1 : 0;
			
			if (isMoving && ! wasMoving) { walkSprite.index++; }
			
			if (doAction1 && noseSprite.currentAnim != "spit") {
				noseSprite.play("spit", true);
				// TODO: shoot rock
			} else if (noseSprite.complete) {
				noseSprite.play("wobble");
			}
		}
		
	}
}

