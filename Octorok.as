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
			walkSprite.originY = 9;
			walkSprite.add("walk", [0, 1], 0.1);
			walkSprite.play("walk");
			
			noseSprite.centerOO();
			noseSprite.originY = 9;
			noseSprite.add("wobble", [0, 1], 0.05);
			noseSprite.add("spit", [2, 3, 0], 0.125, false);
			noseSprite.play("wobble");
			
			setHitbox(10, 10, 5, 5);
			
			type = "octorok";
			
			hurtBy = ["leever", "octorok_spit", "spike"];
		}
		
		public override function nativeBehaviour (): void
		{
			super.nativeBehaviour();
			
			if (FP.rand(8) == 0) {
				var p:Creature = Room(world).player;
				
				var diffX:int = p.x - x;
				var diffY:int = p.y - y;
				
				if (facingY != 0 && diffX >= -4 && diffX <= 4) {
					if ((facingY > 0) == (diffY > 0)) {
						doAction1 = true;
					}
				}
				
				if (facingX != 0 && diffY >= -4 && diffY <= 4) {
					if ((facingX > 0) == (diffX > 0)) {
						doAction1 = true;
					}
				}
			}
		}
		
		public override function doMovement (): void
		{
			var solidTypes:Array = ["octorok_solid", "octorok", "solid"];
			
			if (! isPlayer) {
				solidTypes.push("spike");
			}
			
			moveBy(dx, dy, solidTypes);
			
			if (isMoving) {
				walkSprite.angle = angle;
				noseSprite.angle = angle;
			}
			
			walkSprite.rate = isMoving ? 1 : 0;
			
			if (isMoving && ! wasMoving) { walkSprite.index++; }
			
			if (doAction1 && noseSprite.currentAnim != "spit") {
				noseSprite.play("spit", true);
			} else if (noseSprite.complete) {
				var vx:Number = facingX;
				var vy:Number = facingY;
				world.add(new RockSpit(x+vx*6, y+vy*6, vx*2, vy*2, this));
				noseSprite.play("wobble");
			}
		}
		
		public function get facingX():int
		{
			return Math.sin(walkSprite.angle*FP.RAD);
		}
		
		public function get facingY():int
		{
			return -Math.cos(walkSprite.angle*FP.RAD);
		}
		
	}
}

