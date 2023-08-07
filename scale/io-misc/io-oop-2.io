
class := Object clone
class forward := method(
  prototypes := call evalArgs
  new_class := if(call hasArgs, prototypes removeAt(0), Object) clone
  prototypes foreach(prototype, new_class appendProto(prototype))
  new_class className := call message name
  call sender setSlot(new_class className, new_class)
)

# multiple inheritance

class Thing do(isPants := false)
class Pants(Thing) do(isPants := true)
class Square(Thing)
class Trousers(Pants)
class SquareTrousers(Square, Trousers)

if (SquareTrousers proto == Square,
  SquareTrousers protos foreach(thing,
    if(thing isPants, "Pants", thing className) print
  )
)