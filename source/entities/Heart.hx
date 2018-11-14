package entities;

import haxepunk.*;
import haxepunk.input.*;
import haxepunk.graphics.*;
import haxepunk.masks.*;
import haxepunk.math.*;
import haxepunk.Tween;
import haxepunk.tweens.misc.*;
import haxepunk.utils.*;
import scenes.*;

class Heart extends MemoryEntity {
    public static inline var BOB_AMOUNT = 0.2;

    private var sprite:Image;
    private var bob:NumTween;

    public function new(x:Float, y:Float) {
        super(x, y);
        layer = -1;
        name = "heart";
        MemoryEntity.loadSfx(["heart"]);
        sprite = new Image("graphics/bigheart.png");
        setGraphic(sprite);
        setHitbox(16, 16);
        bob = new NumTween(TweenType.PingPong);
        bob.tween(-BOB_AMOUNT, BOB_AMOUNT, 1, Ease.sineInOut);
        addTween(bob, true);
    }

    public override function update() {
        y += bob.value;
        if(Player.areAllPlayersAtFullHealth()) {
            sprite.alpha = 0.33;
        }
        else {
            sprite.alpha = 1;
            var _player = collide("player", x, y);
            if(_player != null) {
                var player = cast(_player, Player);
                player.pickUpHeart();
                explode(2, 0.1);
                MemoryEntity.allSfx["heart"].play();
                scene.remove(this);
            }
        }
        super.update();
    }
} 

