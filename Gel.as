package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Gel extends Creature
	{
		[Embed(source="images/gel.png")] public static const Gfx: Class;
		
		public var sprite:Spritemap;
		
		public function Gel (_x:Number = 0, _y:Number = 0)
		{
			super(_x, _y);
			
			graphic = sprite = new Spritemap(Gfx, 16, 16);
			
			sprite.centerOO();
			
			sprite.add("wobble", [0, 1], 0.05);
			sprite.play("wobble");
			
			setHitbox(6, 4, 3, 1);
			
			type = "gel";
			
			hurtBy = ["octorok_spit", "spike"];
		}
		
		public override function doMovement (): void
		{
			var solidTypes:Array = ["hero_solid", "solid", "spike"];
			
			moveBy(dx*0.5, dy*0.5, solidTypes);
		}
		
	}
}

