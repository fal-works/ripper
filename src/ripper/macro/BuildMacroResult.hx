package ripper.macro;

import haxe.macro.Expr;

#if macro
/**
	The return type of a build macro function.
	Actually an array of `Field`s.
**/
typedef BuildMacroResult = Null<Array<Field>>;
#end
