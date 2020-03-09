# ripper

A small library for building up classes from reusable components  
(which is also called Mixin or Partial Implementation).

Inspired by [hamaluik/haxe-partials](https://github.com/hamaluik/haxe-partials).

**Requires Haxe 4** (tested with v4.0.5).


## Usage

Prepare a class that you want to use as a component of another class.

Implement `ripper.Spirit` interface here.

```haxe
class Attacker implements ripper.Spirit {
	public function attack() {
		trace('Player attacked!');
	}
}
```

Then create a class which actually uses the component above.

Implement `ripper.Body` interface here,  
and specify which class(es) to use in the `@:ripper.spirits` metadata.

```haxe
@:ripper.spirits(Attacker)
class Player implements ripper.Body {
	public function new() {}
}
```

Now every field of `Attacker` is copied to `Player`.

```haxe
class Main {
	public static function main() {
		final player = new Player();
		player.attack();
	}
}
```

Finally the output below  
(at default this library prints some [INFO] logs during the compilation.  
 See "Compiler flags" below for details).

```
[INFO]   Player.hx | Player | Copied fields: Player <= Attacker
Attacker.hx:3: Player attacked!
```

## More details

### Metadata `@:ripper.spirits()` syntax

- It can also have multiple parameters.
- You can write multiple `@:ripper.spirits()` lines as well.
- A module subclass can also be specified.

```haxe
@:ripper.spirits(my_pkg.Attacker, my_pkg.Magician)
@:ripper.spirits(my_pkg.Attacker.HardAttacker)
```

The classes can be specified with:
- Absolute package path, or
- Relative package path from the current package  
(however the parent packages cannot be referred. Only sub-folders).

### Sharing fields among classes

To share the same fields between `Body`/`Spirit` classes,  
create another base class that has the fields, and let `Body`/`Spirit` classes extend it.

Although the fields of `Spirit` class are copied to `Body` class,  
fields of super-classes are not copied by this process,  
thus you can avoid "Duplicate class field declaration" errors here.

### Using completion server

If you are using [completion server](https://haxe.org/manual/cr-completion-server.html),
sometimes it might go wrong and raise odd errors due to the reusing of macro context.

In that case you may have to reboot it manually (if VSCode, `>Haxe: Restart Language Server`).


## Compiler flags

|flag|description|
|---|---|
|ripper_validation_disable|Disables all validation during the compilation.|
|ripper_log_disable|Disables printing logs (excluding the warning compilation message).|
|ripper_log_debug|Enables printing logs of Debug level.|

### Disable validation/log

If you are sure that your code works fine,  
you may want to disable the debugging features with the following flags:

`-D ripper_validation_disable`
`-D ripper_log_disable`

### Debug log

With the flag `-D ripper_log_debug` set, you can see more detailed log messages when compiling.

Such as:

```
[DEBUG]  Initialize Spirit fields map. (ripper.macro.SpiritMacro::fieldsMap)
[DEBUG]  Player.hx | Player | Start to build Body class.
[DEBUG]  Player.hx | Player | Start to process metadata parameter: Attacker
[DEBUG]  Player.hx | Player | Searching type: Attacker
[DEBUG]  Player.hx | Player | Found type "Attacker". Resolving as a class.
[DEBUG]  Attacker.hx | Attacker | Start registration of Spirit fields.
[DEBUG]  Attacker.hx | Attacker | Registered Spirit fields for copying to Body.
[DEBUG]  Attacker.hx | Attacker | Exclude this type from compilation. End registration.
[DEBUG]  Player.hx | Player | Resolved "Attacker" as a class. Start to copy fields.
[DEBUG]  Player.hx | Player | Copying field: attack
[INFO]   Player.hx | Player | Copied fields: Player <= Attacker
[DEBUG]  Player.hx | Player | End building.
```
