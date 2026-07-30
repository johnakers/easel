package model;

class Weapon {
    public var id:Int;
    public var name:String;
    public var weaponType:Int;
    public var spriteFrameId:Int;
    public var power:Int;

    public function new(id:Int, name:String, weaponType:Int, spriteFrameId:Int, power:Int) {
        this.id = id;
        this.name = name;
        this.weaponType = weaponType;
        this.spriteFrameId = spriteFrameId;
        this.power = power;
    }
}
