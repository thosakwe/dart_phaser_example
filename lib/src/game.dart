import 'dart:html' show window;
import 'package:phaser/phaser.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

abstract class Sprites {
  static const String PLAYER = 'player';
}

class ExampleGame {
  CursorKeys keys;
  Sprite player;
  Body playerBody;
  int speed = 30;

  void start() {
    new Game(
        window.innerWidth,
        window.innerHeight,
        Phaser.AUTO,
        'phaser-example',
        jsify({
          'preload': allowInterop(preload),
          'create': allowInterop(create),
          'update': allowInterop(update),
          'render': allowInterop(render)
        }));
  }

  preload(Game game) {
    game.load.spritesheet(Sprites.PLAYER, 'assets/character.png', 32, 48);
  }

  create(Game game) {
    // Init physics
    game.physics.startSystem(Physics.ARCADE);

    // Input
    keys = game.input.keyboard.createCursorKeys();

    // Characters
    player = game.add.sprite(0, 0, Sprites.PLAYER);
    game.physics.enable(player);

    // Add some animations
    player.animations
      ..add('up', ArrayUtils.numberArray(12, 15), 5)
      ..add('down', ArrayUtils.numberArray(0, 3), 5)
      ..add('left', ArrayUtils.numberArray(4, 7), 5)
      ..add('right', ArrayUtils.numberArray(8, 11), 5);

    // Center the player
    player
      ..anchor.setTo(0.5)
      ..x = game.world.width / 2
      ..y = game.world.height / 2;

    // And have him collide with the world bounds
    (playerBody = player.body).collideWorldBounds = true;
  }

  update(Game game) {
    if (keys.up.isDown) {
      player.animations.play('up');
      playerBody.velocity.y = speed * -1;
    } else if (keys.down.isDown) {
      player.animations.play('down');
      playerBody.velocity.y = speed;
    } else {
      playerBody.velocity.y = 0;
    }

    if (keys.left.isDown) {
      player.animations.play('left');
      playerBody.velocity.x = speed * -1;
    } else if (keys.right.isDown) {
      player.animations.play('right');
      playerBody.velocity.x = speed;
    } else {
      playerBody.velocity.x = 0;
    }
  }

  render(Game game) {
    game.debug.spriteInfo(player, 20, 20);
  }
}
