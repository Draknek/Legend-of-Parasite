package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Tektite extends Creature
	{
		[Embed(source="images/tektite.png")] public static const Gfx: Class;
		
		public var sprite:Spritemap;
		
		public function Tektite (_x:Number = 0, _y:Number = 0)
		{
			super(_x, _y);
			
			graphic = sprite = new Spritemap(Gfx, 16, 16);
			
			sprite.centerOO();
			
			sprite.add("wobble", [0], 0.05);
			sprite.play("wobble");
			
			setHitbox(16, 16, 8, 8);
			
			type = "tektite";
			
			hurtBy = ["octorok_spit", "spike"];
		}
		
		public override function doMovement (): void
		{
			var solidTypes:Array = ["hero_solid", "solid", "spike"];
			
			moveBy(dx, dy, solidTypes);
		}
		
	}
}

