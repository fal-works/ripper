package roles;

class Attacker implements ripper.Spirit {
	public function attack() {
		trace('Player attacked!');
	}
}

class HardAttacker implements ripper.Spirit {
	public function attackHard() {
		trace('Player attacked hard!!');
	}
}
