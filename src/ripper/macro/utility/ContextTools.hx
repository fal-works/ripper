package ripper.macro.utility;

#if macro
using sneaker.format.StringExtension;
using sneaker.macro.extensions.TypeExtension;

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
		Tries to resolve the module, then finds class in that module.
		@return Class instance as `haxe.macro.Type`. `null` if not found.
	**/
	public static function findClassyTypeOrSubType(classPath: String): Null<MacroType> {
		var found: Null<MacroType> = null;

		var module: Null<MacroModule> = null;
		module = tryGetModule(classPath);

		if (module != null) {
			// classPath == modulePath
			if (notVerified) debug('  ${classPath} => Found.');

			found = findClassyTypeIn(module, classPath);
			if (found != null) return found;

			if (notVerified) debug('    Type not found in that module.');
		} else {
			if (notVerified) debug('  ${classPath} => Not found.');
		}

		final lastDotIndex = classPath.lastIndexOfDot();
		final beforeLastDot = classPath.substr(0, lastDotIndex);
		module = tryGetModule(beforeLastDot);

		if (module != null) {
			// classPath = modulePath.subClassName
			if (notVerified) debug('  ${beforeLastDot} => Found.');

			final secondLastDotIndex = beforeLastDot.lastIndexOfDot();
			final beforeSecondDot = beforeLastDot.substr(0, secondLastDotIndex);
			final subclassPath = beforeSecondDot + classPath.substr(lastDotIndex);
			found = findClassyTypeIn(module, subclassPath);
			if (found != null) return found;

			if (notVerified) debug('    Type not found in that module.');
		} else {
			if (notVerified) debug('  ${beforeLastDot} => Not found.');
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
		if (notVerified) debug("Resolving module...");

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
