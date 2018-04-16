package textbox.effects;

import flixel.util.FlxColor;

class ColorEffect implements IEffect
{
    private var active:Bool;
    public function new()
    {
        color = new FlxColor(FlxColor.WHITE);
        active = false;
    }

    public function reset(arg1:Int, arg2:Int, arg3:Int, nthCharacter:Int):Void
    {
        color.red = arg1;
        color.green = arg2;
        color.blue = arg3;
    }

    public function update(elapsed:Float):Void
    {
    }

    public function apply(text:Text):Void
    {
        text.color = color;
    }

    public function setActive(active:Bool):Void
    {
        this.active = active;
    }

    public function isActive():Bool
    {
        return active;
    }

    var color:FlxColor;
}