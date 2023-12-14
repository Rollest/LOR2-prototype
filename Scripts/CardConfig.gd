extends Resource
class_name CardConfig

@export var count : int
@export var power : int
@export var base : int
@export var keywords:Array[Keyword]

func setvalues(Count:int,Power:int,Base:int):
	self.count=Count
	self.power=Power
	self.base=Base

func _get_class():
	return "CardConfig"
