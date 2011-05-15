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
		
		// Cleverness
		public const JUMP_TIME:Number = 16;
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
				inputDX = 0;
				inputDY = 0;
				
				if (FP.rand(8) == 0) {
					randomDirection(FP.choose(0.5, 1.0));
				
					checkBorder();
				}
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
				var jumpTime:int = JUMP_TIME; // N.B. this is actually half jump-time
				
				if (! checkTerrain(dx, dy, jumpTime, solidTypes)) {
					if (checkTerrain(dx, dy, jumpTime*2, solidTypes)) {
						vz = JUMP_V;
						jumpTime = jumpTime*2;
					} else {
						dx = 0;
						dy = 0;
					}
				}
				
				var ix:int = 8*int((x + 4)/8);
				var iy:int = 8*int((y + 4)/8);
				
				if (isPlayer) {
					if ((dx && (ix%16 == 0)) || (dy && (iy%16 == 0))) {
						jumpTime *= 0.5
						vz = JUMP_V*0.5;
					}
				}
				
				var targetDX:int = ix + dx*jumpTime;
				var targetDY:int = iy + dy*jumpTime;
				
				targetDX += FP.rand(3) - 1;
				targetDY += FP.rand(3) - 1;
				
				FP.tween(this, {x: targetDX, y: targetDY}, jumpTime, {tweener: this});
			}
			
			if (isJumping) {
				z += vz;
				vz -= G;
				sprite.play("jump");
				
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
		
		public override function updateTweens():void
		{
			if (canMove) super.updateTweens();
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

