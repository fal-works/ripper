package ripper.macro.utility;

#if macro
import haxe.macro.Expr;

class ExprExtension {
	/**
		Validates that `expression` is a valid domain name representation
		(which is dot-separated, e.g. `pack.subpack.MyModule.MyClass`)
		@return A `String` representation of `expression`, or `null` if invalid.
	**/
	public static function validateDomainName(expression: Expr): Null<String> {
		return switch expression.expr {
			case EConst(constant):
				switch (constant) {
					case CIdent(identifier): identifier;
					default: null;
				}
			case EField(beforeDotExpression, afterDot):
				final beforeDot = validateDomainName(beforeDotExpression);
				if (beforeDot != null) '${beforeDot}.${afterDot}'; else null;
			default:
				null;
		};
	}

	/**
		@return `true` if `a` and `b` are deeply equal.
	**/
	public static function equalImport(a: ImportExpr, b: ImportExpr): Bool {
		if (!std.Type.enumEq(a.mode, b.mode)) return false;

		final pathA = a.path;
		final pathB = b.path;
		final len = pathA.length;
		if (len != pathB.length) return false;

		for (i in 0...len) {
			final nodeA = pathA[i];
			final nodeB = pathB[i];
			if (nodeA.name != nodeB.name) return false;
		}

		return true;
	}
}
#end
