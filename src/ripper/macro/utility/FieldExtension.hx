package ripper.macro.utility;

#if macro
class FieldExtension {
	/**
		@return `true` if `this` field has a metadata with `name`.
	**/
	public static function hasMetadata(_this: Field, name: String): Bool {
		final metadataArray = _this.meta;
		if (metadataArray == null) return false;

		for (i in 0...metadataArray.length)
			if (metadataArray[i].name == name) return true;

		return false;
	}
}
#end
