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
		
		public var inputDX:Number = 0;
		public var inputDY:Number = 0;
		
		public var doAction1:Boolean = false;
		public var doAction2:Boolean = false;
		
		public var wasMoving:Boolean = false;
		public var isMoving:Boolean = false;
		
		public var preferAxis:String = "x";
		
		public var canDiagonal:Boolean = false;
		public const DIAGONAL_SCALE:Number = 1.0/Math.sqrt(2.0);
		
		public var moveTimer:int = 0;
		
		public var hurtBy:Array;
		
		public var canMove:Boolean = true;
		public var isAlive:Boolean = true;
		
		public function Creature (_x:int = 0, _y:int = 0)
		{
			x = _x;
			y = _y;
		}
		
		public function nativeBehaviour (): void
		{
			const TIMER:int = 32;
			
			if (moveTimer == 0) {
				doAction1 = (FP.rand(8) == 0);
				
				var r:int = FP.rand(6);
			
				if (r != 0) { // r == 0: keep going in same direction
					inputDX = 0;
					inputDY = 0;
				
					if (r == 1) inputDX = 1;
					else if (r == 2) inputDX = -1;
					else if (r == 3) inputDY = 1;
					else if (r == 4) inputDY = -1;
			
					inputDX *= 0.5;
					inputDY *= 0.5;
				}
				
				const BOUNDS:int = 16;
				
				var cx:Number = x+inputDX*TIMER - world.camera.x;
				var cy:Number = y+inputDY*TIMER - world.camera.y;
				
				if (cx < BOUNDS || cx > Room.WIDTH - BOUNDS) {
					inputDX *= -1;
				}
				
				if (cy < BOUNDS || cy > Room.HEIGHT - BOUNDS) {
					inputDY *= -1;
				}
				
				moveTimer = TIMER;
			}
			
			moveTimer--;
		}
		
		/*public override function added ():void
		{
			doInput();
		}*/
		
		public function doMovement (): void
		{
			moveBy(dx, dy, type+"_solid");
		}
		
		public function doInput (): void
		{
			doAction1 = false;
			doAction2 = false;
			
			if (! isPlayer) {
				nativeBehaviour();
				return;
			}
			
			inputDX = Number(Input.check(Key.RIGHT)) - Number(Input.check(Key.LEFT));
			inputDY = Number(Input.check(Key.DOWN)) - Number(Input.check(Key.UP));
			
			if (Input.pressed(Key.LEFT) || Input.pressed(Key.RIGHT)) preferAxis = "y";
			else if (Input.pressed(Key.UP) || Input.pressed(Key.DOWN)) preferAxis = "x";
			
			doAction1 = Input.pressed("ACTION1");
			doAction2 = Input.pressed("ACTION2");
		}
		
		public function checkDeath ():void
		{
			for each (var t:String in hurtBy) {
				var e:Entity = collide(t, x, y);
				
				if (e) {
					if (e is Projectile) {
						if (Projectile(e).owner == this) {
							continue;
						}
						
						world.remove(e);
						e = Projectile(e).owner;
					}
					
					var died:Creature = this;
					
					collidable = false;
					
					var nextHost:Creature = e as Creature;
					
					var willTransfer:Boolean = true;
					
					if (!nextHost || ! nextHost.isAlive) {
						willTransfer = false;
					}
					
					var effect:Image;
					
					FP.tween(died, {color: 0xFF0000}, 30, { tweener: FP.tweener });
					
					FP.tween(died, {alpha: 0.0}, 30, {
						tweener: FP.tweener,
						delay: 15,
						complete: function ():void
						{
							if (died.isPlayer) {
								var room:Room = Room(world);
								
								if (willTransfer) {
									room.player = nextHost;
									nextHost.isPlayer = true;
									nextHost.canMove = true;
								} else {
									nextHost = new room.spawnClass(room.spawnX, room.spawnY);
									nextHost.isPlayer = true;
									nextHost.canMove = false;
									
									var nextRoom:Room = new Room(room.ix, room.iy, nextHost);
									
									FP.world = nextRoom;
									nextRoom.active = false;
									
									effect = Image.createRect(Room.WIDTH, Room.HEIGHT, 0xFFFFFF, 0.75);
									effect.scrollX = effect.scrollY = 0;
									
									FP.tween(effect, {alpha: 0.0}, 45, function ():void {
										nextHost.canMove = true;
										nextRoom.active = true;
									});
						
									nextRoom.addGraphic(effect, -1000);
								}
							}
							
							world.remove(died);
						}
					});
					
					if (died.isPlayer && willTransfer) {
						nextHost.canMove = false;
						
						effect = Image.createRect(32, 32, 0xFFFFFF, 0.5);
						
						effect.centerOO();
						
						effect.x = nextHost.x;
						effect.y = nextHost.y;
						
						FP.tween(effect, {angle: 45, alpha: 0.0}, 60);
						
						world.addGraphic(effect);
					}
					
					canMove = false;
					isAlive = false;
					graphic.active = false;
					return;
				}
			}
		}
		
		public function get color ():uint { return 0xFFFFFF; }
		
		public function set color (c:uint):void
		{
			if (graphic is Image) {
				Image(graphic).color = c;
			} else if (graphic is Graphiclist) {
				for each (var g:Graphic in Graphiclist(graphic).children) {
					if (g is Image) {
						Image(g).color = c;
					}
				}
			}
		}
		
		public function get alpha ():Number { return 1.0; }
		
		public function set alpha (n:Number):void
		{
			if (graphic is Image) {
				Image(graphic).alpha = n;
			} else if (graphic is Graphiclist) {
				for each (var g:Graphic in Graphiclist(graphic).children) {
					if (g is Image) {
						Image(g).alpha = n;
					}
				}
			}
		}
		
		public override function update (): void
		{
			if (canMove) {
				wasMoving = isMoving;
				doInput();
			
				dx = inputDX;
				dy = inputDY;
			
				if (canDiagonal && dx && dy) {
					dx *= DIAGONAL_SCALE;
					dy *= DIAGONAL_SCALE;
				}
			
				if (! canDiagonal) {
					if (dx && dy) {
						this["d"+preferAxis] = 0;
					}
				
					if (dx) straighten("y");
					else if (dy) straighten("x");
				}
			
				isMoving = (dx || dy);
				doMovement();
			}
			
			if (isAlive) {
				checkDeath();
			}
			
			layer = -y;
		}
		
		public function get angle (): Number
		{
			var theta:Number = (Math.atan2(dy, dx) * FP.DEG);
			
			theta = Math.round(theta / 90.0) * 90.0;
			
			return theta - 90;
			
			// old code
			if (dx > 0.6) return -90;
			if (dx < -0.6) return 90;
			if (dy > 0.6) return 180;
			return 0;
		}
		
		public function straighten (axis:String):void
		{
			var N:int = 2;
			
			var p:int = this[axis] % (N*2);
			
			var delta:int = 0;
			
			if (p == 0) return
			else if (p < N) delta = -1;
			else if (p > N) delta = 1;
			else if (p == N) {
				p = this[axis] % (N*4);
				
				if (p < N*2) delta = -1;
				else delta = 1;
			}
			
			this["d"+axis] = delta * 0.25;
		}
		
		public function get isPlayer ():Boolean { return _isPlayer; }
		public function set isPlayer (b:Boolean):void {
			if (_isPlayer == b) return;
			
			_isPlayer = b;
			
			if (_isPlayer) becamePlayer();
		}
		
		public function becamePlayer ():void {}
		
		private var _isPlayer:Boolean = false;
		
	}
}

