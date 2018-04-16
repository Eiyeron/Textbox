package textbox.effects;

import flixel.util.FlxColor;

class RainbowEffect implements IEffect
{
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
        hue = (hue + hueSpeed * elapsed) % 360.;
    }

    public function apply(text:Text):Void
    {
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

    private var active:Bool = false;
    private var hue:Float;
    private var hueSpeed:Float;
}