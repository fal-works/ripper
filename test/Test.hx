class Test {
	public static function main() {
		final player = new Player.ExtendedPlayer("Noname", 20);
		player.attack();
		player.magic();
		player.attackHard();
		player.heal();

		final data: MyData = {
			myInt: 1,
			myFloat: 2.0,
			myString: "a"
		}
		trace(data.myInt);
	}
}
