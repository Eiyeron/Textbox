package textbox.effects;

import flixel.util.FlxColor;

class RainbowEffect implements IEffect
{
    private var active:Bool;

    public function new()
    {
        hue = 0;
        hueSpeed = 0;
    }

    public function reset(_startingHue:Int, _hueSpeed:Int, arg3:Int, nthCharacter:Int):Void
    {
        hue = _startingHue;
        hueSpeed = _hueSpeed*15;
    }

    public function update(elapsed:Float):Void
    {
        if (!isActive())
            return;

        hue = (hue + hueSpeed * elapsed) % 360.;
    }

    public function apply(text:Text):Void
    {
        if (!isActive())
            return;


        text.color = FlxColor.fromHSL(hue, 0.5, 0.5);
    }

    public function setActive(active:Bool):Void
    {
        this.active = active;
    }


    public function isActive():Bool
    {
        return active;
    }

    var enabled:Bool;
    var hue:Float;
    var hueSpeed:Float;
}