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
}
#end
