package ripper.macro;

#if macro
import haxe.ds.StringMap;
import haxe.macro.Compiler;

class SpiritMacro {
	/**
		Mapping from `Spirit` classes to arrays of fields.
		Used as a buffer for storing fields that will be copied to `Body` classes.
	**/
	@:persistent public static final fieldsMap = {
		// Call MacroLogger.debug() directly as the wrapper may not yet be initialized.
		sneaker.macro.MacroLogger.debug('Initialize Spirit fields map.');
		new StringMap<Array<Field>>();
	}

	/**
		A build macro that is run for each `Spirit` classes.
		Registers fields to `fieldsMap` and also excludes the type itself from compilation.
	**/
	macro public static function register(): Null<Fields> {
		final localClassRef = Context.getLocalClass();
		if (localClassRef == null) {
			warn('Tried to build something that is not a class.');
			return null;
		}

		final localClass = localClassRef.get();
		setVerificationState(localClass);

		if (notVerified) debug('Start registration of Spirit fields.');

		final localType = Context.getLocalType();
		if (localType == null) {
			warn('Tried to process something that is not a type.');
			return null;
		}

		final localTypePath = TypeTools.toString(localType);

		final localFields = Context.getBuildFields();
		fieldsMap.set(localTypePath, localFields);
		if (localFields.length > 0)
			if (notVerified) debug('Registered Spirit fields for copying to Body.');
		else
			warn('Marked as Spirit but no fields for copying to Body.');

		if (!localClass.meta.has(preserveMetadataName)) {
			if (notVerified) debug('Exclude this type from compilation.');
			Compiler.exclude(localTypePath, false);
		}

		if (notVerified) debug('End registration.');

		return null;
	}
}
#end
