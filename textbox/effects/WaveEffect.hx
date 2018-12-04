package textbox.effects;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxTween.FlxTweenType;
import flixel.tweens.FlxEase;
import textbox.Text;

class WaveEffect implements IEffect
{

    public function new()
    {
    }

    /**
     *  @param easingKind - Bound between 0 and 2. Defaulting in linear if out bounds.
     *  @param height - Bound between 0 and 255, converted into a max offset between 0 and 30px.
     *  @param duration - Bound between 0 and 255, converted into a duration between 200ms and 5s.
     *  @param nthCharacter - Unused
     */
    public function reset(easingKind:Int, height:Int, speed:Int, nthCharacter:Int):Void
    {
        var selectedEase:EaseFunction;
        switch (easingKind)
        {
            case 0:
            selectedEase = FlxEase.linear;

            case 1:
            selectedEase = FlxEase.cubeOut;

            case 2:
            selectedEase = FlxEase.bounceOut;

            // Add more if you feel like so.
            default:
            selectedEase = FlxEase.linear;
        }

        var mappedHeight:Float = height/255. * 30;
        var mappedDuration:Float = (speed*(10-0.2))/255. + 0.2;

        offsetY = -mappedHeight;

        tween = FlxTween.tween
        (
            this,
            {offsetY: mappedHeight},
            mappedDuration,
            {
                type: FlxTweenType.PINGPONG,
                ease: selectedEase
            }
        );
    }

    public function update(elapsed:Float):Void
    {
    }

    public function apply(text:Text):Void
    {
        text.offset.y = offsetY;
    }

    public function setActive(active:Bool):Void
    {
        this.active = active;
    }

    public function isActive():Bool
    {
        return active;
    }

    private var tween:FlxTween;
    private var offsetY:Float;
    private var active:Bool = false;
}