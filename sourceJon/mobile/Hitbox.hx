package mobile;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class Hitbox extends FlxSpriteGroup
{
	public var buttonLeft:FlxButton;
	public var buttonDown:FlxButton;
	public var buttonUp:FlxButton;
	public var buttonRight:FlxButton;

	public var left(get, never):Bool;
	public var down(get, never):Bool;
	public var up(get, never):Bool;
	public var right(get, never):Bool;

	public function new()
	{
		super();

		var zoneWidth:Int = Std.int(FlxG.width / 4);
		var zoneHeight:Int = FlxG.height;

		buttonLeft  = createZone(0,             0, zoneWidth, zoneHeight, FlxColor.RED);
		buttonDown  = createZone(zoneWidth,     0, zoneWidth, zoneHeight, FlxColor.BLUE);
		buttonUp    = createZone(zoneWidth * 2, 0, zoneWidth, zoneHeight, FlxColor.GREEN);
		buttonRight = createZone(zoneWidth * 3, 0, zoneWidth, zoneHeight, FlxColor.MAGENTA);

		add(buttonLeft);
		add(buttonDown);
		add(buttonUp);
		add(buttonRight);

		scrollFactor.set();
	}

	private function createZone(x:Float, y:Float, width:Int, height:Int, color:FlxColor):FlxButton
	{
		var zone:FlxButton = new FlxButton(x, y);
		zone.makeGraphic(width, height, color);
		zone.alpha = 0.00001;
		zone.solid = false;
		zone.immovable = true;
		zone.scrollFactor.set();
		#if FLX_DEBUG
		zone.ignoreDrawDebug = true;
		#end
		return zone;
	}

	inline function get_left():Bool  return buttonLeft.status  == FlxButton.PRESSED;
	inline function get_down():Bool  return buttonDown.status  == FlxButton.PRESSED;
	inline function get_up():Bool    return buttonUp.status    == FlxButton.PRESSED;
	inline function get_right():Bool return buttonRight.status == FlxButton.PRESSED;

	override public function destroy():Void
	{
		super.destroy();
		buttonLeft  = null;
		buttonDown  = null;
		buttonUp    = null;
		buttonRight = null;
	}
}
