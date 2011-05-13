package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Stalfos extends Creature
	{
		[Embed(source="images/stalfos.png")] public static const Gfx: Class;
		
		public var sprite:Spritemap;
		
		public var dir:String = "Down";
		
		public function Stalfos (_x:Number = 0, _y:Number = 0)
		{
			super(_x, _y);
			
			graphic = sprite = new Spritemap(Gfx, 32, 32);
			
			sprite.centerOO();
			
			setHitbox(16, 16, 8, 8);
			
			sprite.add("walkDown", [0, 1], 0.05);
			sprite.add("attackDown", [2], 0.05, false);
			sprite.add("walkUp", [3, 4], 0.05);
			sprite.add("attackUp", [5], 0.05, false);
			sprite.add("walkRight", [6, 7], 0.05);
			sprite.add("attackRight", [8], 0.05, false);
			sprite.add("walkLeft", [9, 10], 0.05);
			sprite.add("attackLeft", [11], 0.05, false);
			
			sprite.play("walkDown");
			
			type = "stalfos";
			
			hurtBy = ["octorok_spit"];
		}
		
		public override function doMovement (): void
		{
			if (sprite.currentAnim.substr(0, 6) == "attack") {
				dx = dy = 0;
			}
			
			if (dy > 0.4) dir = "Down";
			else if (dy < -0.4) dir = "Up";
			else if (dx > 0.4) dir = "Right";
			else if (dx < -0.4) dir = "Left";
			
			var walkAnim:String = "walk" + dir;
			var attackAnim:String = "attack" + dir;
			
			moveBy(dx, dy, "hero_solid");
			
			if (sprite.complete || ((dx || dy) && sprite.currentAnim != walkAnim)) sprite.play(walkAnim);
			
			if (doAction1) sprite.play(attackAnim);
		}
		
	}
}

