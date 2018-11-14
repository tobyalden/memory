import flash.system.System;
import haxepunk.*;
import haxepunk.debug.Console;
import haxepunk.input.*;
import haxepunk.input.gamepads.*;
import haxepunk.utils.*;
import openfl.ui.Mouse;
import scenes.*;

class Main extends Engine {
    public static var music:Sfx;
    public static var gamepad:Gamepad;
    private static var delta:Float;

    private static var previousJumpHeld:Bool = false;

    public static function getDelta() {
        return delta;
    }

	static function main() {
		new Main();
	}

	override public function init() {
#if debug
        Console.enable();
#end
        Mouse.hide();
        HXP.fullscreen = true;
        HXP.screen.color = 0x000000;
        HXP.scene = new MainMenu();

        Key.define("left", [Key.LEFT, Key.LEFT_SQUARE_BRACKET]);
        Key.define("right", [Key.RIGHT, Key.RIGHT_SQUARE_BRACKET]);
        Key.define("up", [Key.UP]);
        Key.define("down", [Key.DOWN]);
        Key.define("jump", [Key.Z, Key.SPACE, Key.ENTER]);
        Key.define("act", [Key.X]);

        Key.define("2P_left", [Key.A]);
        Key.define("2P_right", [Key.D]);
        Key.define("2P_up", [Key.W]);
        Key.define("2P_down", [Key.S]);
        Key.define("2P_jump", [Key.Q]);
        Key.define("2P_act", [Key.E]);

        gamepad = Gamepad.gamepad(0);
        Gamepad.onConnect.bind(function(newGamepad:Gamepad) {
            if(gamepad == null) {
                gamepad = newGamepad;
            }
        });
	}

    override public function update() {
        delta = HXP.elapsed * 60;
        if(Key.pressed(Key.ESCAPE)) {
            System.exit(0);
        }
        super.update();
        if(gamepad != null) {
            previousJumpHeld = gamepad.check(XboxGamepad.A_BUTTON);
        }
    }

    public static function inputPressed(inputName:String, playerNum:Int = 1) {
        var playerPrefix = playerNum == 1 ? "" : "2P_";
        if(gamepad == null || Input.pressed(playerPrefix + inputName)) {
            return Input.pressed(playerPrefix + inputName);
        }
        if(inputName == "jump") {
            if(!previousJumpHeld && gamepad.check(XboxGamepad.A_BUTTON)) {
                return true;
            }
        }
        if(inputName == "act") {
            return gamepad.pressed(XboxGamepad.X_BUTTON);
        }
        return false;
    }

    public static function inputReleased(inputName:String, playerNum:Int = 1) {
        var playerPrefix = playerNum == 1 ? "" : "2P_";
        if(gamepad == null || Input.released(playerPrefix + inputName)) {
            return Input.released(playerPrefix + inputName);
        }
        if(inputName == "jump") {
            if(previousJumpHeld && !gamepad.check(XboxGamepad.A_BUTTON)) {
                return true;
            }
        }
        if(inputName == "act") {
            return gamepad.released(XboxGamepad.X_BUTTON);
        }
        return false;
    }

    public static function inputCheck(inputName:String, playerNum:Int = 1) {
        var playerPrefix = playerNum == 1 ? "" : "2P_";
        if(gamepad == null || Input.check(playerPrefix + inputName)) {
            if(inputName == "left" && Input.check(playerPrefix + "right")) {
                return false;
            }
            if(inputName == "right" && Input.check(playerPrefix + "left")) {
                return false;
            }
            return Input.check(playerPrefix + inputName);
        }
        if(inputName == "jump") {
            return gamepad.check(XboxGamepad.A_BUTTON);
        }
        if(inputName == "act") {
            return gamepad.check(XboxGamepad.X_BUTTON);
        }
        if(inputName == "left") {
            return (
                gamepad.getAxis(0) < -0.5
                || gamepad.check(XboxGamepad.DPAD_LEFT)
            );
        }
        if(inputName == "right") {
            return (
                gamepad.getAxis(0) > 0.5
                || gamepad.check(XboxGamepad.DPAD_RIGHT)
            );
        }
        if(inputName == "up") {
            return (
                gamepad.getAxis(1) < -0.5
                || gamepad.check(XboxGamepad.DPAD_UP)
            );
        }
        if(inputName == "down") {
            return (
                gamepad.getAxis(1) > 0.5
                || gamepad.check(XboxGamepad.DPAD_DOWN)
            );
        }
        return false;
    }
}
