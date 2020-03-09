package roles;

class Attacker implements ripper.Spirit {
	public function attack() {
		trace('${this} attacked!');
	}
}

class HardAttacker implements ripper.Spirit {
	public function attackHard() {
		trace('${this} attacked hard!!');
	}
}
