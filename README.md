# BLOCKCHAIN TEMPLATE BUILDER

Il progetto consiste in uno script bash che mira a **semplificare la creazione di precompile contracts** durante la creazione di una blockchain, attraverso lo strumento Avalanche in [precompile-EVM](https://github.com/ava-labs/precompile-evm).
Lo script si presenta come funzione "wrapper" dei passaggi 1-3 della [fase di creazione di precompile](https://build.avax.network/academy/avalanche-l1/customizing-evm/07-hash-function-precompile/00-intro).
Altamente consigliata è la conoscenza del funzionamento di precompile-evm. [Qui](https://build.avax.network/academy/avalanche-l1/customizing-evm) si può seguire il tutorial fornito da Avalanche Builder Hub.


## Funzionamento base in precompile-EVM

1. **Creare un'interfaccia Solidity per il precompile**
2. **Generare l'ABI**
3. **Scrivere il codice GO del precompile**
4. Configurare e registrare il precompile
5. Creare ed eseguire test


## Il problema

La creazione di interfacce Solidity, assieme alla scrittura in Go della logica dei precompile contracts, può risultare lenta se non persino ostica, specialmente per un Contract Developer alle prime armi.
Viene immediata la necessità di avere uno strumento che implementi **template** sicuri, efficienti, affidabili e personalizzabili di precompile contracts. 
Se i template sono gestiti da una community attiva, come quella di Avalanche, allora qualsiasi Contract Developer che utilizzi precompile-evm avrà a disposizione migliaia di strumenti per lo sviluppo della propria blockchain, velocizzando le tempistiche di coding e riducendo eventuali errori o bug al minimo.


## La soluzione

Fornire al Contract Developer la scelta di utilizzare template o partire da zero.
Nel caso in cui venga la prima opzione, lo script è avviato e viene data la possibilità di selezionare un modello di blockchain (e.g. blockchain per transazione di criptovalute).
Successivamente si potrà scegliere un insieme di precompile contracts.

Esempio:

```





```
## Manutenibilità dei template

Il progetto è interamente community driven.
Per ora si bassa interamente su precompile-evm, ma in futuro può basarsi su una L1 standalone.

L'idea è quella di integrare il nostro progetto con precompile-evm, affinché possa essere costantemente aggiornato in modo sicuro.
Più il numero di utenti che contribuiscono al progetto, fornendo template di blockchain
e funzioni, più gli stessi utenti avranno a disposizione strumenti affidabili per lo sviluppo della propria blockchain. Dunque, in un futuro non troppo lontano, qualsiasi programmatore, indipendentemente dalla sua esperienza, potrà virtualmente usufruire di moltissimi modelli per qualsiasi blockchain.


# TODO

marketplace di tameplate
gestione piu sicura degli errori durante l'esecuzione dello script

