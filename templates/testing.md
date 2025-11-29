# CONTRACT: SumValues

## DESCRIPTION: Returns the sum of two values

## SOL INTERFACE: function sumValues(uint32 a, uint32 b) external returns (uint64 sum);

## GO IMPLEMENTATION:

// Get numbers from input structure
a := inputStruct.A
b := inputStruct.B

// Compute sum
var output uint64
output = uint64(a) + uint64(b)

---
