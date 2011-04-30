package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Creature extends Entity
	{
		public var dx: Number = 0;
		public var dy: Number = 0;
		
		public var isPlayer:Boolean = false;
		
		public var doAction1:Boolean = false;
		public var doAction2:Boolean = false;
		
		public var wasMoving:Boolean = false;
		public var isMoving:Boolean = false;
		
		public function Creature (_x:Number = 0, _y:Number = 0)
		{
			x = _x;
			y = _y;
		}
		
		public function nativeBehaviour (): void
		{
			if (FP.rand(8) == 0) {
				dx = FP.rand(3) - 1;
				dy = FP.rand(3) - 1;
			}
		}
		
		public function doMovement (): void
		{
			x += dx;
			y += dy;
		}
		
		public function doInput (): void
		{
			doAction1 = false;
			doAction2 = false;
			
			if (! isPlayer) {
				nativeBehaviour();
				return;
			}
			
			dx = Number(Input.check(Key.RIGHT)) - Number(Input.check(Key.LEFT));
			dy = Number(Input.check(Key.DOWN)) - Number(Input.check(Key.UP));
			
			doAction1 = Input.pressed(Key.X);
			doAction2 = Input.pressed(Key.C);
		}
		
		public override function update (): void
		{
			wasMoving = isMoving;
			doInput();
			isMoving = (dx || dy);
			doMovement();
		}
		
		public function get angle (): Number
		{
			if (dx > 0.4) return -90;
			if (dx < -0.4) return 90;
			if (dy > 0.4) return 180;
			return 0;
		}
	}
}

