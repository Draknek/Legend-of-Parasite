package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	import flash.display.*;
	
	public class Switch extends Entity
	{
		public static var state:int = 0;
		
		public var sprite:Spritemap;
		
		[Embed(source="images/switch-blocks.png")] public static const Gfx: Class;
		
		public function Switch (_x:Number, _y:Number)
		{
			super(_x, _y);
			
			sprite = new Spritemap(Gfx, 16, 16);
			sprite.frame = 2 + state*3;
			sprite.centerOO();
			
			graphic = sprite;
			
			setHitbox(16, 16, 8, 8);
			
			type = "switch";
		}
		
		public override function update ():void
		{
			if (Input.pressed(Key.TAB)) {
				toggle();
			}
		}
		
		public function toggle ():void
		{
			state = state ? 0 : 1;
			
			var a:Array = [];
			
			world.getClass(Switch, a);
			
			for each (var s:Switch in a) {
				s.sprite.frame = 2 + state*3;
			}
			
			a = [];
			
			world.getClass(SwitchBlock, a);
			
			for each (var b:SwitchBlock in a) {
				b.updateState();
			}
		}
	}
}

