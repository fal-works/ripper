package ripper.common;

#if macro
import haxe.macro.Expr;

class ExprExtension {
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
