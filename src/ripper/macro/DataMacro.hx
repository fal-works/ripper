package ripper.macro;

#if macro
import prayer.Values.nullField;

using Lambda;
using haxe.macro.TypeTools;
using sneaker.macro.extensions.MacroResultExtension;

class DataMacro {
	/**
		A build macro that is run for each `Data` classes.
		Completes the arguments and expressions of `new()` according to the non-initialized variables.
	**/
	public static macro function build(): Null<Fields> {
		final localClassResult = ContextTools.getLocalClassRef();
		if (localClassResult.isFailedWarn()) return null;
		final localClassRef = localClassResult.unwrap();
		final localClass = localClassRef.get();

		setVerificationState(localClass);
		if (notVerified) debug('Start completing constructor.');

		final buildFields = Context.getBuildFields();

		final expressions: Array<Expr> = [];
		final arguments: Array<FunctionArg> = [];
		var access: Array<Access> = [APublic];
		var position = Context.currentPos();
		var documentation: Null<String> = 'Creates `${localClass.name}` instance.';
		var metadata: Null<Metadata> = null;

		final meta = localClass.meta;
		final callSuper = localClass.superClass != null
			&& (meta.has(callSuperMetadataName) || meta.has(callSuperMetadataName_));
		if (callSuper) {
			if (notVerified) {
				debug('Found metadata: $callSuperMetadataName');
				debug('  Inject super constructor call without arguments.');
			}

			expressions.push(macro super());
		}

		if (notVerified) debug('Scan non-initialized variables.');
		for (field in buildFields) {
			switch (field.kind) {
				case FVar(type, expression) if (expression == null):
					final name = field.name;
					if (notVerified) debug('  - $name');
					expressions.push(macro this.$name = $i{name});
					arguments.push({
						name: name,
						type: type
					});
				default:
			}
		}

		final existingConstructor = buildFields.findByName("new");
		if (existingConstructor != nullField) {
			if (notVerified) debug('Found an existing constructor.');
			buildFields.remove(existingConstructor);
			switch (existingConstructor.kind) {
				case FFun(func):
					if (func.expr != null) expressions.push(func.expr);
					final args = func.args.copy();
					args.reverse();
					for (arg in args) arguments.unshift(arg);
					position = existingConstructor.pos;
					documentation = existingConstructor.doc;
					metadata = existingConstructor.meta;
					if (existingConstructor.access != null) access = existingConstructor.access;
				default:
			}
		} else {
			if (notVerified) debug('Create a new constructor.');
		}

		final constructor: Field = {
			name: "new",
			access: access,
			kind: FFun({
				args: arguments,
				ret: null,
				expr: macro $b{expressions}
			}),
			pos: position,
			doc: documentation,
			meta: metadata
		};

		buildFields.push(constructor);

		if (notVerified) {
			debug('Add arguments and expressions to constructor.');
			debug('End completing constructor.');
		}

		return buildFields;
	}
}
#end
