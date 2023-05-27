# simple-banking-service-code-challenge

## TL;DR

```
make            # will install and build

make build      # run tests and demo only
```

## Instrctions

```
make            # install and build

make usage      # see other makefile usage options

make build      # run tests and demo only

make rspec      # run tests

make rubocop    # run rubocop
```

## Assumptions

TODO ... this will come out of incomplete work from the Work Log analysis

## Work Log

- [x] added make file
- [x] add standard as a standard set of rubocop rules as per
    https://evilmartians.com/chronicles/rubocoping-with-legacy-bring-your-ruby-code-up-to-standard
- [x] add rspec via `bundle add rspec` with defautls
- [x] add ruby 3.2.2 (latest non preview) using [asdf](https://asdf-vm.com/)
- [ ] iteration 0
    - [ ] setup build pipeline: rspec, rubocop, tool-version, make file, GitHub
      actions test runner?
    - [ ] instructions for it to just work? would Docker be a better default
    - [ ] an end to end test, say `spec/features`
    - [ ] how to run this? and what is the output? maybe apply the "simple
      system" guiding principle and just create a unix terminal app in
      `bin/simple_banking_service.rb`
    - [ ] a simple way to run it? say `make` as it is on every computer
- [ ] how to meet expectations of the Rubrick
    - [ ] uses domain models, hmm pull out the Domain Driven Design book and
      see how best to apply bounded contexts?
    - [ ] idea of using native data structures, arrays, hashes? is there a need
      for anything more complicated?
    - [ ] use rspec
    - [ ] coverage? not a coverage report fan but might be an idea? my view is
      everything is covered by an outside in BDD test as well as a TDD unit
      test
    - [ ] tests are orthogonal? pull out the dictionary - do we mean
      "orthogonal" asa synonmy for "independent" ie they don't crash if one
      thing breaks, they all break? in my BDD/TDD approach I would expect most
      of the time 2 tests to fail the outside in BDD describing what behaviour
      has broken and a TDD unit tests showing what causes that to break?
    - [ ] tests explain the functionality Object Orientation - I presume there
      is a missing comma here? should be functionality, Object Orientation? ie
      if a FileParser returns an array of Account objects or if a debit 100
      occurs on an account with 10 an error is raised
    - [ ] encapsulation, seperation of concerns, short methods, readable all
      the good things
    - [ ] runs and provides feedback - error, success, output
    - [ ] calculates test files accurately - presumably the provided files
      `mable_acc_balance.csv` and `mable_trans.csv`
- [ ] anlyse the problem
    - [ ] Daily CSV file with transfers
        - [ ] how big?
        - [ ] only CSV?
        - [ ] how identified as daily?
    - [ ] transfers they want to make between accounts for customers they are
      doing business with
        - [ ] how to deal with customers they are NOT doing business with
        - [ ] how to deal with customers they USED to do business with
        - [ ] is there any chance of wrong data?
        - [ ] what if the transfers were run for a historical date? where a
          customer is no longer on the "do business with list" is this a
          possiblitly?
    - [ ] Accounts are identified by 16 digit number
        - [ ] is this important? does it need validation? what if the account
          ID is not valid?
    - [ ] money cannot be transferred from them that will put the account
      balance below $0
        - [ ] is this just the ending balance? ie can Account X transfer
          negative during the day and end in positive?
    - [ ] implement a simple system
        - [ ] implement so code needs to be written
        - [ ] "simple system" could be used as a guiding principle
    - [ ] can load account balances for a single company
        - [ ] how many balances is that? what would be a reasonable limit in
          terms of size?
    - [ ] then accept a day's transfers in a CSV file
        - [ ] again only CSV
        - [ ] a "day's" transfer - how big? what is the limit?
        - [ ] does "accept" a day's transfers mean "Actually calculate the
          remaining balances" or only "accpet" that the transfers do not go
          below $0? I am guessing a safe assumption is both? although this is
          not clear?
        - [ ] also does "accept" mean this "simple banking service" is actually
          performing the transfers? clearly not as there is no banking API to
          move funds between accounts or simple saying the file provided is
          "acceptable" as in the accounts exist and nothing goes below 0 so it
          can be passed onto an actual banking app to perform the transfers?
    - [ ] on size of balance and transfers
        - [ ] what is considered reasonable?
        - [ ] what is the limit on size of either file for memory/system
          resources and time?
    - [x] example files provided would result in a balance (as calculated by
      hand)

        | Account          | Balance   | Calculations     |
        | :--------------- | --------: | :--------------- |
        | 1111234522226789 |   4820.50 | -500 + 320.50    |
        | 1111234522221234 |   9974.40 | - 25.60          |
        | 2222123433331212 |    550.00 | + 1000           |
        | 1212343433335665 |   1200.00 | + 500 + 25.60    |
        | 3212343433335755 |  50000.00 | - 1000 - 320.50  |

    - [ ] probably should use a Money library like the Money gem
    - [ ] doing the manual calclations above kind of resembles a double entry
      ledger, where every calculation has an associated debit and credit
        - [ ] might be good to represent this in the modelling of the problem
        - [ ] presumably a debit and credit have to happen a the same time in a
          sort of transaction or not happen at all
        - [ ] every transaction should happen only once, so may need to make
          sure they are idempotent, maybe by line number in the CSV? or could
          build out a sort of ledger like a cheap version of a blockchain,
          where the MD5 hash of the previous transactions need to be calculated
          prior to pefrorming the next transaction? not sure if that sits with
          "Simple system" but sounds like fun 👨‍💻
        - [ ] could the transactions ever be split into separate threads?
          workers? asynchronous jobs to scale and process quickly?
        - [ ] would there be any value in adding a caching layer at any point,
          in case files are too large?
        - [ ] would other technology choices like a database or something like
          Apache Arrow (in-memory analytics) have benefits here? I did a tech
          talk at RORO meetup - 120X faster than ruby CSV

          [![Data pipelines in Rails and Postgres - Micheal Millewski
            ](http://img.youtube.com/vi/cCm7-zagbwY/0.jpg)
            ](https://youtu.be/cCm7-zagbwY?t=1203s)

          and was actually recently mentioned at RubyKaigi Matsumoto Japan in a
          talk about ADBC Arrow DataBase Connectivity slides available on
          https://www.clear-code.com/blog/2023/5/15/rubykaigi-2023.html
        - [ ] this also brings up a question of if it is better to tackle this
          on more of an ObjectOriented fashion with objects representing the
          core parts of the system: `FileParsing`, `Accounts`, `Transactions`,
          `Balance`, `BalanceWriter` or more of a Functional fashion with
          functions representing various transformations:
          `FileToInitalBalance`, `FileToTransfers`, `ApplyTransfersToAccounts`,
          `AccountsToOutput` an interesting view point on this was presented
          back at RailsConf Minnieapolis 2019

          [![Sprinkles of Functional Programming by John Schoeman
            ](http://img.youtube.com/vi/toSedSFnzOE/0.jpg)
            ](https://youtu.be/toSedSFnzOE)

          the code for that
          https://github.com/johnschoeman/sprinkles-of-functional-programming
- [x] move problem statement into Markdown
    - https://github.com/saramic/simple-banking-service-code-challenge
- [x] move work into git repo

## Code Challenge

You are a developer for a company that runs a very simple banking service. Each
day companies provide you with a CSV file with transfers they want to make
between accounts for customers they are doing business with. Accounts are
identified by a 16 digit number and money cannot be transferred from them if it
will put the account balance below $0. Your job is to implement a simple system
that can load account balances for a single company and then accept a day's
transfers in a CSV file. An example customer balance file is provided as well
as an example days transfers.

| Starting state of accounts for Account | customers of Alpha Sales: Balance |
| :------------------------------------- | --------------------------------: |
| 1111234522226789                       |                           5000.00 |
| 1111234522221234                       |                          10000.00 |
| 2222123433331212                       |                            550.00 |
| 1212343433335665                       |                           1200.00 |
| 3212343433335755                       |                          50000.00 |

Single day transacitons for Alpha sales:

| from             | to               | amount  |
| :--------------- | :--------------- | ------: |
| 1111234522226789 | 1212343433335665 |  500.00 |
| 3212343433335755 | 2222123433331212 | 1000.00 |
| 3212343433335755 | 1111234522226789 |  320.50 |
| 1111234522221234 | 1212343433335665 |   25.60 |

## Rubrick

### Data Structure

- uses domain models
- uses native data structures readably

### Tests
- uses rspec
- has some coverage
- has good coverage
- tests are orthogonal
- tests explain the functionality Object Orientation
- models encapsulate logic appropriately
- respects separation of concerns
- short methods
- readable methods General
- runs and provides feedback
- calculates test files accurately

