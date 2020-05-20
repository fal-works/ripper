@:structInit
class MyData implements ripper.Data {
	public final myInt: Int;
	public final myFloat: Float;
	public final myString: String;
}

class ExMyData extends MyData {
	public final myInt2: Int;

	public function new() {
		super(0, 0.0, "a");
	}
}
