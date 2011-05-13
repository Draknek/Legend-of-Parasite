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
		public const JUMP_TIME:Number = 15;
		public const JUMP_HEIGHT:Number = 8;
		
		// s = ut + 0.5at^2
		// s = JUMP_HEIGHT, u = 0, t = JUMP_TIME
		// a = 2*s/t^2
		public const G:Number = 2*JUMP_HEIGHT/JUMP_TIME/JUMP_TIME;
		
		// s/t = 0.5*(u+v)
		// s = JUMP_HEIGHT, v = 0, t = JUMP_TIME
		// u = 2*s/t
		public const JUMP_V:Number = 2*JUMP_HEIGHT/JUMP_TIME;
		
		
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
			
			graphic = new Graphiclist(shadow, sprite);
			
			setHitbox(16, 16, 8, 8);
			
			type = "tektite";
			
			hurtBy = ["octorok_spit", "spike"];
		}
		
		public override function doMovement (): void
		{
			var solidTypes:Array = ["hero_solid", "solid", "spike"];
			
			if (z <= 0 && delay >= jumpDelay) {
				if (doAction1) {
					vz = JUMP_V;
				} else if (dx || dy) {
					vz = JUMP_V*0.75;
				}
			}
			
			if (z > 0 || vz > 0) {
				z += vz;
				vz -= G;
				sprite.play("jump");
				
				moveBy(dx, dy, solidTypes);
				
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
		
	}
}

