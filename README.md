
<div style="display: flex; align-items: center; gap: 40px;">

  <img src="./photos/beluga_logo_notext.png" width="200" style="display: block;">

  <img src="./photos/ascii-art-text.png" width="600" style="display: block;">

</div>

Il progetto consiste in uno script bash che mira a **semplificare la creazione di precompile contracts** durante la creazione di una blockchain, attraverso lo strumento Avalanche in [Precompile-EVM](https://github.com/ava-labs/precompile-evm).

Lo script si presenta come funzione "wrapper" dei passaggi 1-4 della [fase di creazione di precompile](https://build.avax.network/academy/avalanche-l1/customizing-evm/07-hash-function-precompile/00-intro).

Altamente consigliata è la conoscenza del funzionamento di Precompile-EVM. [Qui](https://build.avax.network/academy/avalanche-l1/customizing-evm) si può seguire il tutorial fornito da Avalanche Builder Hub.


## Funzionamento base in Precompile-EVM

1. **Creare un'interfaccia Solidity per il precompile**
2. **Generare l'ABI**
3. **Scrivere il codice GO del precompile**
4. **Configurare e registrare il precompile**
5. Creare ed eseguire test


## Il problema

La creazione di interfacce Solidity, assieme alla scrittura in Go della logica dei precompile contracts, può risultare lenta se non persino ostica, specialmente per un Contract Developer alle prime armi.

Viene immediata la necessità di avere uno strumento che implementi **template** sicuri, efficienti, affidabili e personalizzabili di precompile contracts.

Se i template sono gestiti da una community attiva, come quella di Avalanche, allora qualsiasi Contract Developer che utilizzi Precompile-EVM avrà a disposizione migliaia di strumenti per lo sviluppo della propria blockchain, velocizzando le tempistiche di coding e riducendo eventuali errori o bug al minimo.


## La soluzione

0. Fornire al Contract Developer la scelta di utilizzare template o di partire da zero.

1. Nel caso in cui venga scelta la prima opzione, lo script è avviato e viene data la possibilità di selezionare un modello di blockchain (e.g. blockchain per transazione di criptovalute).

2. Successivamente si potranno scegliere, da un insieme di precompile contracts predefiniti, tutti i contratti che il Developer desidera usare.

3. Se il Contract Developer desidera aggiungere i propri precompile contracts, è adesso invitato ad inserire le firme nell'opportuno file di Interfaccia`.sol`

4. Vengono quindi create le implementazioni dei precompile

5. Infine vengono eseguite configurazioni finali (assegnazione dell'indirizzo di ogni precompile...)

Esempio di utilizzo:

0. (scelto di usare template)
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

## Manutenibilità dei template

Il progetto è pensato per essere interamente community driven.

Per ora si basa interamente su Precompile-EVM, ma in futuro può basarsi su una L1 standalone.

L'idea è quella di avere un luogo sicuro, custodito ed aggiornato da una community attiva, per i template dei precompile contracts. 

Più è il numero degli utenti che contribuiscono al progetto, fornendo template di blockchain
e funzioni, più gli stessi utenti avranno a disposizione strumenti affidabili per lo sviluppo della propria blockchain.

Dunque, in un futuro non troppo lontano, qualsiasi programmatore, indipendentemente dalla sua esperienza, potrà usufruire di moltissimi modelli per qualsiasi blockchain.


# TODO

* Marketplace di tameplate

* Gestione piu sicura degli errori durante l'esecuzione dello script

* Aggiungere sezione che gestisca eventuali librerie esterne richieste dai contracts

