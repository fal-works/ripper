package ripper.macro;

#if macro
import haxe.macro.PositionTools;
import haxe.macro.ExprTools;
import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.macro.Expr;
import haxe.rtti.Meta;
import haxe.ds.StringMap;
import sneaker.log.MacroLogger;
import sneaker.string_buffer.StringBuffer;
import sneaker.print.Printer.println;
import haxe.macro.TypeTools;

using ripper.common.ExprExtension;
using sneaker.log.MacroLogger;
using sneaker.format.StringExtension;

typedef BuildMacroResult = Null<Array<Field>>;

enum MetadataParameterProcessResult {
	InvalidType;
	NotFound;
	NotClass;
	Failure;
	NoFields;
	Success;
}

class Macro {
	static final logPrefix = "[RIPPER]";
	static final logSeparator = " | ";

	static function log(content: Dynamic) {
		final buffer = new StringBuffer();
		buffer.addPrefixFilePosition(logPrefix);
		buffer.add(logSeparator);
		buffer.add(Context.getLocalClass());
		buffer.add(logSeparator);
		buffer.add(content);
		println(buffer.toString());
	}

	static final partials = new StringMap<Array<Field>>();

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
		final validated = parameter.validateDomainName();
		if (validated == null) return InvalidType;
		#end

		log('Searching for type "${parameterString}" ...');

		final type = findType(parameterString);
		#if !ripper_validation_disable
		if (type == null) return NotFound;
		#end

		final fullTypeName = TypeTools.toString(type);
		log('Found type "${fullTypeName}". Resolving as a class...');
		final className = resolveClass(type, fullTypeName);

		#if !ripper_validation_disable
		if (className == null) return NotClass;
		#end

		log('Resolved "${className}" as a class. Start to copy fields...');
		final fields = partials.get(fullTypeName);

		#if !ripper_validation_disable
		if (fields == null) return Failure;
		if (fields.length == 0) return NoFields;
		#end

		for (field in fields) {
			field.pos = Context.currentPos();
			localFields.push(field);
			log('Copied field "${field.name}".');
		}

		return Success;
	}

	static function processAsHost(metadataArray: Array<MetadataEntry>): BuildMacroResult {
		final localFields = Context.getBuildFields();

		for (metadata in metadataArray) {
			final metadataParameters = metadata.params;
			if (metadataParameters == null) {
				log("Found metadata without arguments. Go to next...");
				continue;
			}
			for (parameter in metadataParameters) {
				final typeName = ExprTools.toString(parameter);
				log('Start to process metadata parameter "${typeName}"...');
				final result = processMetadataParameter(parameter, typeName, localFields);

				switch result {
					case InvalidType:
						log('"${typeName}" is an invalid type name.');
					case NotFound:
						log('Type "${typeName}" not found.');
					case NotClass:
						log('"${typeName}" is not a class.');
					case Failure:
						log('Failed to get fields data of ${typeName} for unknown reason.');
					case NoFields:
						log('No fields in ${typeName}.');
					case Success:
						log('Copied fields from ${typeName}.');
				}
			}
		}

		return localFields;
	}

	static function processAsPart(): BuildMacroResult {
		final localTypePath = TypeTools.toString(Context.getLocalType());

		final localFields = Context.getBuildFields();
		partials.set(localTypePath, localFields);
		log('Saved fields in ${localTypePath}.');

		Compiler.exclude(localTypePath, false);
		log('Excluded ${localTypePath} from compilation.');

		return null;
	}

	macro public static function process(): BuildMacroResult {
		log("Start processing.");

		final localClass = Context.getLocalClass();
		if (localClass == null) {
			log("Tried to process something that is not a class. Go to next...");
			return null;
		}

		final metadataArray = localClass.get().meta.extract(":partials");
		final metadataExists = metadataArray.length > 0;

		final result: BuildMacroResult = if (metadataExists) {
			log("Found metadata.");
			processAsHost(metadataArray);
		}
		else {
			log("No metadata. Registering as a part...");
			processAsPart();
		}

		log("end processing");
		return result;
	}
}
#end
