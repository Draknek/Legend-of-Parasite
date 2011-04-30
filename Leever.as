package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Leever extends Creature
	{
		[Embed(source="images/leever.png")] public static const LeeverGfx: Class;
		
		public var sprite:Spritemap;
		
		public function Leever (_x:Number = 0, _y:Number = 0)
		{
			super(_x, _y);
			
			graphic = sprite = new Spritemap(LeeverGfx, 16, 16);
			
			sprite.centerOO();
			
			//sprite.add("down", [0, 1], 0.1);
			
			//sprite.play("down");
		}
		
		public override function doMovement (): void
		{
			x += dx;
			y += dy;
		}
		
	}
}

