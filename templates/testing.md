# CONTRACT: PrintToSTDOUT

## DESCRIPTION: prints to STDOUT

## SOL INTERFACE: function printSTDOUT(string memory message) external;

## GO IMPLEMENTATION:

//Get message from input structure
message := inputStruct.Message

//Print message to STDOUT
fmt.Println(message)

---
