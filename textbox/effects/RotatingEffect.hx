package textbox.effects;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxTween.FlxTweenType;
import flixel.tweens.FlxEase;
import textbox.Text;

class RotatingEffect implements IEffect
{

    public function new()
    {
    }

    /**
     *  @param easingKind - Bound between 0 and 2. Defaulting in linear if out bounds.
     *  @param angle - Bound between 0 and 255, converted into a max rotation between 0 and 180°
     *  @param duration - Bound between 0 and 255, converted into a duration between 200ms and 5s.
     *  @param nthCharacter - Unused
     */
    public function reset(easingKind:Int, angle:Int, duration:Int, nthCharacter:Int):Void
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

        var mappedAngle:Float = angle/255. * 180;
        var mappedDuration:Float = (duration*(10-0.2))/255. + 0.2;

        rotationAngle = -mappedAngle;

        tween = FlxTween.tween
        (
            this,
            {rotationAngle: mappedAngle},
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
        text.angle = rotationAngle;
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
    private var rotationAngle:Float;
    private var active:Bool = false;
}