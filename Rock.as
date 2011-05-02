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
		
		public function Rock (_x:Number, _y:Number)
		{
			super(_x, _y);
			
			graphic = new Stamp(RockGfx, -8, -8);
			
			setHitbox(16, 16, 8, 8);
			
			type = "solid";
		}
		
	}
}

