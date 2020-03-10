package ripper.macro;

#if macro
using sneaker.format.StringExtension;
using sneaker.macro.TypeExtension;

import haxe.macro.Context;
import sneaker.macro.ContextTools.tryGetModule;

class ContextTools {
	/**
		Find class with `classPath` in `module`.
		@return Class instance as `haxe.macro.Type`. `null` if not found.
	**/
	public static function findClassyTypeIn(
		module: MacroModule,
		classPath: String
	): Null<MacroType> {
		for (type in module)
			if (type.isClassWithName(classPath)) return type;

		return null;
	}

	/**
		Find class from `classPath`.
		@return Class instance as `haxe.macro.Type`. `null` if not found.
	**/
	public static function findClassyTypeOrSubType(classPath: String): Null<MacroType> {
		var found: Null<MacroType> = null;

		debug("Resolving module...");
		var module: Null<MacroModule> = null;
		module = tryGetModule(classPath);
		if (module == null) {
			debug('  ${classPath} => Not found.');
			final lastDotIndex = classPath.lastIndexOfDot();
			final beforeLastDot = classPath.substr(0, lastDotIndex);
			module = tryGetModule(beforeLastDot);
			if (module == null) {
				debug('  ${beforeLastDot} => Not found.');
				return null;
			} else {
				debug('  ${beforeLastDot} => Found.');
				final secondLastDotIndex = beforeLastDot.lastIndexOfDot();
				final beforeSecondDot = beforeLastDot.substr(0, secondLastDotIndex);
				final subclassPath = beforeSecondDot + classPath.substr(lastDotIndex);
				found = findClassyTypeIn(module, subclassPath);
				if (found != null) return found;
			}
		} else {
			debug('  ${classPath} => Found.');
			found = findClassyTypeIn(module, classPath);
			if (found != null) return found;
		}

		return null;
	}

	/**
		Find class from `classPath`.
		Also tries to find the class assuming that `classPath` is a relative path in the current package
		(only the classes that are in the current package or any of its sub-packages can be found).
		@return Class instance as `haxe.macro.Type`. `null` if not found.
	**/
	public static function findClassyType(classPath: String): Null<MacroType> {
		final type = findClassyTypeOrSubType(classPath);
		if (type != null) return type;

		final localModulePath = Context.getLocalModule();
		final lastDotIndex = localModulePath.lastIndexOfDot();
		if (lastDotIndex < 0) return null; // Already in root package

		final localPackagePath = localModulePath.substr(0, lastDotIndex);
		return findClassyTypeOrSubType('${localPackagePath}.${classPath}');
	}
}
#end
