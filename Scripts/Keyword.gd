extends Resource
class_name Keyword


@export var type:KeywordType
@export var value:int
@export var duration: int #-1 means duration does not do shit for this effect
@export var trigger: int #used to determine what coin triggers this on cards -1 means applied to self
enum KeywordType{
	BURN,
	POISON,
	SHRED,
	FINAL_POWER,
	COIN_POWER,
	ARMOR,
	SPEED,
	MANA,
	DRAW,
}
func _new(type:KeywordType,val:int,dur:int,trig:int):
	self.type=type
	self.value=val
	self.duration=dur
	self.trigger=trig

func copy(base:Keyword):
	type=base.type
	value=base.value
	duration=base.duration
	trigger=base.trigger

	
