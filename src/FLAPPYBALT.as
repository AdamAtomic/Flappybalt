package
{
	import org.flixel.*;
	[SWF(width="480", height="720", backgroundColor="#000000")]

	public class FLAPPYBALT extends FlxGame
	{
		public function FLAPPYBALT()
		{
			super(160,240,PlayState,3,50,50);
			
			FlxG.debug = true;
		}
	}
}
