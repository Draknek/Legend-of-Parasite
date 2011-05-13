package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Tektite extends Creature
	{
		[Embed(source="images/tektite.png")] public static const Gfx: Class;
		[Embed(source="images/shadow.png")] public static const ShadowGfx: Class;
		
		public var sprite:Spritemap;
		public var shadow:Image;
		
		public var z:Number = 0;
		public var vz:Number = 0;
		
		public var delay:int = 0;
		public var jumpDelay:int = 10;
		
		public var jumpDX:Number = 0;
		public var jumpDY:Number = 0;
		
		// Cleverness
		public const JUMP_TIME:Number = 15;
		public const JUMP_HEIGHT:Number = 8;
		
		// s/t = 0.5*(u+v)
		// s = JUMP_HEIGHT, v = 0, t = JUMP_TIME
		// u = 2*s/t
		public const JUMP_V:Number = 2*JUMP_HEIGHT/JUMP_TIME;
		
		// v = u + at
		// v = JUMP_V, u = 0, t = JUMP_TIME
		// a = v/t
		public const G:Number = JUMP_V/JUMP_TIME;
		
		public function Tektite (_x:Number = 0, _y:Number = 0)
		{
			super(_x, _y);
			
			sprite = new Spritemap(Gfx, 16, 16);
			
			sprite.centerOO();
			
			sprite.add("wait", [0]);
			sprite.add("jump", [1]);
			sprite.play("wait");
			
			shadow = new Image(ShadowGfx);
			shadow.centerOO();
			shadow.alpha = 0;
			
			//graphic = new Graphiclist(shadow, sprite);
			// N.B. if you re-add the shadow, you need to remove it at death
			graphic = sprite;
			
			setHitbox(14, 14, 7, 7);
			
			type = "tektite";
			
			hurtBy = ["octorok_spit", "spike"];
		}
		
		public override function nativeBehaviour ():void
		{
			if (canJump) {
				randomDirection(1.0);
				
				checkBorder();
			}
			
		}
		
		public override function doMovement (): void
		{
			var solidTypes:Array = ["hero_solid", "solid", "spike"];
			
			if (canJump && (dx || dy)) {
				// De-straightenify
				if (dx > -0.4 && dx < 0.4) dx = 0;
				if (dy > -0.4 && dy < 0.4) dy = 0;
				
				vz = JUMP_V*0.5;
				jumpDX = dx*0.5;
				jumpDY = dy*0.5;
				
				if (checkTerrain(jumpDX, jumpDY, 16, solidTypes)) {
					if (FP.rand(2)) {
						if (checkTerrain(dx, dy, 16, solidTypes)) {
							jumpDX = dx;
							jumpDY = dy;
						}
					}
				} else {
					if (checkTerrain(dx*2, dy*2, 16, solidTypes)) {
						jumpDX = dx;
						jumpDY = dy;
						vz = JUMP_V;
					} else {
						jumpDX = 0;
						jumpDY = 0;
					}
				}
			}
			
			if (isJumping) {
				z += vz;
				vz -= G;
				sprite.play("jump");
				
				moveBy(jumpDX, jumpDY);
				
				delay = 0;
				jumpDelay = 5 + FP.rand(15);
			}
			
			if (z <= 0) {
				z = 0;
				vz = 0;
				sprite.play("wait");
				delay += 1;
			}
			
			sprite.y = -z;
		}
		
		public override function render ():void
		{
			//shadow.alpha = 0.25 + Math.sqrt(z / JUMP_HEIGHT) * 0.5;
			
			super.render();
		}
		
		public function get canJump ():Boolean
		{
			return (z <= 0 && delay >= jumpDelay);
		}
		
		public function get isJumping ():Boolean
		{
			return (z > 0 || vz > 0);
		}
		
	}
}

