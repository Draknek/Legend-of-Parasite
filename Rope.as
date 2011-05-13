package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Rope extends Creature
	{
		[Embed(source="images/rope.png")] public static const Gfx: Class;
		
		public var sprite:Spritemap;
		
		public function Rope (_x:Number = 0, _y:Number = 0)
		{
			super(_x, _y);
			
			graphic = sprite = new Spritemap(Gfx, 16, 16);
			
			sprite.centerOO();
			
			sprite.add("wobble", [0, 1], 0.05);
			sprite.play("wobble");
			
			setHitbox(16, 16, 8, 8);
			
			type = "rope";
			
			hurtBy = ["octorok_spit", "spike"];
		}
		
		public override function doMovement (): void
		{
			var solidTypes:Array = ["hero_solid", "solid", "spike"];
			
			moveBy(dx*2, dy*2, solidTypes);
			
			if (dx > 0) sprite.flipped = true;
			if (dx < 0) sprite.flipped = false;
		}
		
	}
}

