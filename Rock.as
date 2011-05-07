package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	import flash.display.*;
	
	public class Rock extends Entity
	{
		[Embed(source="images/rock.png")] public static const RockGfx: Class;
		
		public function Rock (_x:Number, _y:Number, index:int)
		{
			super(_x, _y);
			
			var sprite:Spritemap = new Spritemap(Overworld.CreaturesGfx, 16, 16);
			sprite.frame = index;
			sprite.centerOO();
			
			graphic = sprite;
			
			setHitbox(16, 16, 8, 8);
			
			type = "solid";
		}
		
	}
}

