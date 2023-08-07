
def := Object clone
def forward := method(
  method_name := call message name
  call message setName("method")
  call sender setSlot(method_name, resend)
)

class := Object clone
class forward := method(
  new_class := Object clone
  call sender setSlot(call message name, new_class)
  call message argsEvaluatedIn(new_class) first
)

# instance

class Norton(
  def scan(thing,
    "Scanning #{thing}...\n" interpolate print
    wait(3)
    "Done! No virus found." print
  )
)

Norton do(
  newSlot("blockEverything", false)
  def lockOutUser(setBlockEverything(true))
)