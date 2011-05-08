package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	import flash.display.*;
	
	public class SwitchBlock extends Entity
	{
		public var sprite:Spritemap;
		
		public var up:Boolean;
		public var color:int;
		
		public function SwitchBlock (_x:Number, _y:Number, index:int)
		{
			super(_x, _y);
			
			sprite = new Spritemap(Switch.Gfx, 16, 16);
			sprite.centerOO();
			
			graphic = sprite;
			
			setHitbox(10, 10, 5, 5);
			
			color = index - Room.CREATURE_CLASSES.indexOf(SwitchBlock);
			
			updateState();
		}
		
		public function updateState ():void
		{
			up = (Switch.state == color);
			
			sprite.frame = color + Switch.state*3;
			
			if (up) {
				type = "solid";
			} else {
				type = "underground";
			}
		}
	}
}

