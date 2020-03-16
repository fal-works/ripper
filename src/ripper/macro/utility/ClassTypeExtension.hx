package ripper.macro.utility;

#if macro
import haxe.macro.Type.ClassType;

class ClassTypeExtension {
	/**
		@return `true` if `this` implements interface with name `interfaceName`.
	**/
	public static function implementsInterface(_this: ClassType, interfaceName: String): Bool {
		final interfaces = _this.interfaces;
		for (i in 0...interfaces.length)
			if (interfaces[i].t.toString() == interfaceName) return true;

		return false;
	}
}
#end
