
<div style="display: flex; align-items: center; gap: 40px;">

  <img src="./photos/beluga_logo_notext.png" width="200" style="display: block;">

  <img src="./photos/ascii-art-text.png" width="600" style="display: block;">

</div>
<br>

The project, which is intended for developers building Subnet-EVM blockchains, consists of a bash script designed to simplify the creation of precompile contracts when building a blockchain using Avalanche’s [Precompile-EVM](https://github.com/ava-labs/precompile-evm).

The script acts as a “wrapper” around steps 1–4 of [the precompile creation workflow](https://build.avax.network/academy/avalanche-l1/customizing-evm/07-hash-function-precompile/00-intro).

A solid understanding of how Precompile-EVM works is strongly recommended. The tutorial provided by Avalanche Builder Hub can be followed [here](https://build.avax.network/academy/avalanche-l1/customizing-evm).


## Basic workflow in Precompile-EVM

1. **Create a Solidity interface for the precompile**
2. **Generate the ABI**
3. **Write the GO implementation of the precompile**
4. **Configure and register the precompile**
5. Create and run tests


## The problem

Creating Solidity interfaces, along with writing the GO logic for precompile contracts, can be time-consuming and at times difficult, especially for inexperienced Contract Developers.

This naturally creates the need for a tool that provides safe, efficient, reliable, and customizable templates for precompile contracts.

If these templates are maintained by an active community such as Avalanche’s, then any Contract Developer using Precompile-EVM would have access to a large set of development tools for their blockchain, reducing coding time and minimizing potential errors or bugs.


## The solution

0. Let the Contract Developer decide whether to start from scratch or with a template.
1. If the first option is chosen, the script is started and allows the user to select a blockchain model (e.g., blockchain for cryptocurrency transactions).
2. The user can then select the contracts they want to include from a set of predefined precompile contracts.
3. If the developer wishes to add their own precompile contracts, they are prompted to it now, by inserting the function signatures into the appropriate `.sol` interface file.
4. The implementations of the precompiles are generated.
5. Final configurations are applied (assigning each precompile's address, etc...).

Example:

0. (Start from tamplate is chosen)
```
./select_template.sh FULL/PATH/TO/precompile-evm

```
1.
```
Select the desired template
Use ↑ ↓ to move, space to select/deselect, Enter to confirm

   [ ] Academic
>  [x] Gaming
   [ ] Social Networking
   [ ] Testing

```
2.
```
Selected template: Gaming 
Choose which contracts you want to implement
Use ↑ ↓ to move, space to select/deselect, Enter to confirm

   [x] GameStateManager
   [ ] VRFVerifier
   [ ] PhysicsEngine
>  [ ] BatchMinter
   [x] ReputationHasher
   [ ] SignatureValidator

Description of BatchMinter
Performs the batch minting of thousands of NFTs with complex metadata in a single transaction. Optimizes storage loops and hashing cycles to significantly reduce gas costs for large minting operations.
```
3.
```
Generated file: YOUR/PATH/TO/precompile-evm/contracts/contracts/interfaces/IGaming.sol

Selected contracts implemented in YOUR/PATH/TO/precompile-evm/contracts/contracts/interfaces/IGaming.sol

* WARNING: If you want to add your custom implementations do it now before continuing *

Press ENTER to proceed with the compilation...

Starting ABI compilation with solc...
ABI file renamed in ./contracts/abi/IGaming.abi
Generating precompile with type=Gaming and pkg=gaming
installing precompilegen from Subnet-EVM v0.7.9
generating precompile with Subnet-EVM v0.7.9
```
4.
```
Precompile files generated successfully at:  ./gaming

Configuration completed!
Edit the generated package before building if you want to fine tune your project

Do you want to already build? [y/N]

```

## Template mantainability

The project is intended to be entirely community-driven.

It currently relies fully on Precompile-EVM, but in the future it may rely on a standalone L1.

The idea is to provide a secure, maintained, and up-to-date location, that is managed by an active community, for precompile contract templates.

The more users contribute blockchain templates and functions, the more reliable tools will be available to everyone for developing their own blockchains.

Thus, in the near future, any programmer—regardless of experience—could rely on a wide range of models for any blockchain.


# TODO

* Template marketplace (A basic graphic implementation is provided)

* Add the ability to use marketplace-bought templates 

* Safer error handling during script execution may be needed.

* Add specific section that allows the addition of external libraries required by precompile contracts.

* Dynamic gas manager for computationally intensive operations.
