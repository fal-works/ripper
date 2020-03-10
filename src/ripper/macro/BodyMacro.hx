package ripper.macro;

#if macro
using Lambda;
using sneaker.format.StringExtension;

import haxe.macro.ExprTools;
import haxe.macro.Type.ClassType;
	#if !ripper_validation_disable
	import ripper.common.ExprExtension.validateDomainName;
	#end

class BodyMacro {
	/**
		A build macro that is run for each `Body` classes.
		Copies fields from `Spirit` classes that are specified by the `@:spirits` metadata.
	**/
	macro public static function build(): Null<Fields> {
		debug('Start to build Body class.');

		final localClass = Context.getLocalClass();
		if (localClass == null) {
			warn('Tried to build something that is not a class.');
			debug('Go to next.');
			return null;
		}

		final localClassName = localClass.toString();
		final metadataArray = localClass.get().meta.extract(":ripper.spirits");

		if (metadataArray.length == 0) {
			warn('Marked as Body but missing @:ripper.spirits metadata for specifying classes from which to copy fields.');
			return null;
		}

		final result: Null<Fields> = processAllMetadata(
			localClassName,
			metadataArray
		);

		debug('End building.');
		return result;
	}

	/**
		Extract the class instance from `type`.
		This process is necessary for invoking the build macro of `type` if not yet called.
	**/
	static function resolveClass(type: MacroType, typeName: String): Null<ClassType> {
		try {
			final classType = TypeTools.getClass(type);
			return classType;
		} catch (e:Dynamic) {
			return null;
		}
	}

	/**
		@return `Field` object that has the same name as `name`. `null` if not found.
	**/
	static function findFieldIn(fields: Array<Field>, name: String): Null<Field> {
		var found: Null<Field> = null;
		for (i in 0...fields.length) {
			final field = fields[i];
			if (field.name != name) continue;
			found = field;
			break;
		}
		return found;
	}

	/**
		Parse a metadata parameter as a class name,
		and adds the fields of that class to `localFields`.
	**/
	static function processMetadataParameter(
		parameter: Expr,
		parameterString: String,
		localFields: Array<Field>
	): MetadataParameterProcessResult {
		#if !ripper_validation_disable
		final validated = validateDomainName(parameter);
		if (validated == null) return InvalidType;
		#end

		debug('Start to search type: ${parameterString}');

		final type = ContextTools.findClassyType(parameterString);
		#if !ripper_validation_disable
		if (type == null) return NotFound;
		#end

		final fullTypeName = TypeTools.toString(type);
		debug('Found type "${fullTypeName}". Resolving as a class.');
		final classType = resolveClass(type, fullTypeName);

		#if !ripper_validation_disable
		if (classType == null) return NotClass;
		#end

		debug('Resolved "${classType.name}" as a class. Start to copy fields.');
		final fields = SpiritMacro.fieldsMap.get(fullTypeName);

		#if !ripper_validation_disable
		if (fields == null) return Failure;
		if (fields.length == 0) return NoFields;
		#end

		for (field in fields) {
			debug('Copying field: ${field.name}');

			#if !ripper_validation_disable
			final sameNameField = findFieldIn(localFields, field.name);
			if (sameNameField != null) {
				warn('  Duplicate field name: ${field.name}');
				continue;
			}
			#end

			final copyingField = Reflect.copy(field);
			copyingField.pos = Context.currentPos();
			localFields.push(copyingField);
		}

		return Success;
	}

	/**
		Process the given metadata array and calls `processMetadataParameter()` for each parameter.
	**/
	static function processAllMetadata(
		localClassName: String,
		metadataArray: Array<MetadataEntry>
	): Null<Fields> {
		final localFields = Context.getBuildFields();

		for (metadata in metadataArray) {
			final metadataParameters = metadata.params;
			#if !ripper_validation_disable
			if (metadataParameters == null) {
				warn("Found metadata without arguments.");
				debug('Go to next.');
				continue;
			}
			#end
			for (parameter in metadataParameters) {
				final typeName = ExprTools.toString(parameter);
				debug('Start to process metadata parameter: ${typeName}');
				final result = processMetadataParameter(
					parameter,
					typeName,
					localFields
				);

				switch result {
					case InvalidType:
						warn('"${typeName}" is an invalid type name.');
					case NotFound:
						warn('Type "${typeName}" not found.');
					case NotClass:
						warn('"${typeName}" is not a class.');
					case Failure:
						warn('Failed to get fields data of "${typeName}" for unknown reason.');
					case NoFields:
						debug('No fields in "${typeName}".');
					case Success:
						#if !ripper_validation_disable
						info('Copied fields: ${localClassName.sliceAfterLastDot()} <= ${typeName.sliceAfterLastDot()}');
						#else
						info('Processed metadata parameter: ${typeName}');
						#end
				}
			}
		}

		return localFields;
	}
}

/**
	Kind of result that `BodyMacro.processMetadataParameter()` returns.
**/
private enum MetadataParameterProcessResult {
	InvalidType;
	NotFound;
	NotClass;
	Failure;
	NoFields;
	Success;
}
#end
