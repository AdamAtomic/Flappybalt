package
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		[Embed(source="data/dove.png")] protected var ImgDove:Class;
		
		public function Player()
		{
			super(FlxG.width*0.5-4, FlxG.height*0.5-4);
			loadGraphic(ImgDove,true,true);
			frame = 2;
			addAnimation("flap",[1,0,1,2],12,false);
		}
		
		override public function update():void
		{
			if(FlxG.keys.justPressed("SPACE"))
			{
				if(acceleration.y == 0)
				{
					acceleration.y = 500;
					velocity.x = 80;
				}
				velocity.y = -240;
				play("flap",true);
			}
		}
		
		override public function kill():void
		{
			if(!exists)
				return;
			super.kill();
			FlxG.flash(0xffffffff,1,onFlashDone);
			FlxG.shake(0.02,0.35);
		}
		
		public function onFlashDone():void
		{
			PlayState.saveScore();
			FlxG.resetState();
		}
	}
}