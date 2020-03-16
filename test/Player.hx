@:ripper.spirits(roles.Attacker, roles.Magician)
@:ripper.spirits(roles.Attacker.HardAttacker)
class Player extends GameCharacter implements ripper.Body {}

@:ripper.spirits(roles.Priest)
class ExtendedPlayer extends Player {}
