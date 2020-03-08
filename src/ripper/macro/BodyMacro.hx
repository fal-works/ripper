package ripper.macro;

#if macro
import haxe.macro.ExprTools;
import ripper.common.ExprExtension.validateDomainName;

using sneaker.format.StringExtension;

class BodyMacro {
	macro public static function build(): BuildMacroResult {
		debug('Start to build Body class.');

		final localClass = Context.getLocalClass();
		if (localClass == null) {
			warn('Tried to build something that is not a class.');
			debug('Go to next...');
			return null;
		}

		final localClassName = localClass.toString();
		final metadataArray = localClass.get().meta.extract(":ripper.spirits");

		if (metadataArray.length == 0) {
			warn('Marked as Body but missing @:ripper.spirits metadata for specifying classes from which to copy fields.');
			return null;
		}

		final result: BuildMacroResult = processAllMetadata(
			localClassName,
			metadataArray
		);

		debug('End building.');
		return result;
	}

	static function findTypeStrict(typeName: String): Null<haxe.macro.Type> {
		try {
			return Context.getType(typeName);
		} catch (e:Dynamic) {
			return null;
		}
	}

	static function findType(typeName: String): Null<haxe.macro.Type> {
		final type = findTypeStrict(typeName);
		if (type != null) return type;

		try {
			final modulePath = Context.getLocalModule();
			final packagePath = modulePath.sliceBeforeLastDot();
			return findTypeStrict('${packagePath}.${typeName}');
		} catch (e:Dynamic) {
			return null;
		}
	}

	static function resolveClass(type: haxe.macro.Type, typeName: String): Null<String> {
		try {
			final classType = TypeTools.getClass(type);
			return classType.name;
		} catch (e:Dynamic) {
			return null;
		}
	}

	static function processMetadataParameter(
		parameter: Expr,
		parameterString: String,
		localFields: Array<Field>
	): MetadataParameterProcessResult {
		#if !ripper_validation_disable
		final validated = validateDomainName(parameter);
		if (validated == null) return InvalidType;
		#end

		debug('Searching for type "${parameterString}" ...');

		final type = findType(parameterString);
		#if !ripper_validation_disable
		if (type == null) return NotFound;
		#end

		final fullTypeName = TypeTools.toString(type);
		debug('Found type "${fullTypeName}". Resolving as a class...');
		final className = resolveClass(type, fullTypeName);

		#if !ripper_validation_disable
		if (className == null) return NotClass;
		#end

		debug('Resolved "${className}" as a class. Start to copy fields...');
		final fields = SpiritMacro.fieldsMap.get(fullTypeName);

		#if !ripper_validation_disable
		if (fields == null) return Failure;
		if (fields.length == 0) return NoFields;
		#end

		for (field in fields) {
			field.pos = Context.currentPos();
			localFields.push(field);
			debug('Copied field "${field.name}".');
		}

		return Success;
	}

	static function processAllMetadata(
		localClassName: String,
		metadataArray: Array<MetadataEntry>
	): BuildMacroResult {
		final localFields = Context.getBuildFields();

		for (metadata in metadataArray) {
			final metadataParameters = metadata.params;
			if (metadataParameters == null) {
				warn("Found metadata without arguments.");
				debug('Go to next...');
				continue;
			}
			for (parameter in metadataParameters) {
				final typeName = ExprTools.toString(parameter);
				debug('Start to process metadata parameter "${typeName}"...');
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
						info('Copied fields: ${localClassName.sliceAfterLastDot()} <= ${typeName.sliceAfterLastDot()}');
				}
			}
		}

		return localFields;
	}
}

private enum MetadataParameterProcessResult {
	InvalidType;
	NotFound;
	NotClass;
	Failure;
	NoFields;
	Success;
}
#end
