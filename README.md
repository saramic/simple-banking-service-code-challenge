# simple-banking-service-code-challenge

## TL;DR

```
make            # will install and build

make build      # run tests and demo only

make demo       # run as below

bin/simple_banking_service.rb mable_acc_balance.csv mable_trans.csv
```

[![CI](https://github.com/saramic/simple-banking-service-code-challenge/actions/workflows/ci.yml/badge.svg)
  ](https://github.com/saramic/simple-banking-service-code-challenge/actions/workflows/ci.yml)

## Instrctions

```
make            # install and build

make usage      # see other makefile usage options

make build      # run tests and demo only

make rspec      # run tests

make rubocop    # run rubocop

open coverage/index.html  # to view coverage
```

added coverage although not a fan of this as if you write your code BDD/TDD you
would expect to have almost double coverage of all the lines. The current
coverage reports

> All Files ( 100.0% covered at 2.65 hits/line )

## Assumptions

1. using a simple Unix terminal script `bin/simple_banking_service.rb`
1. any errors will be simply propagated to STDERR in Unix terminal
1. any errors will return a non zero, failing exit code
1. the first file is always considered to be the account balances with the
   first 2 columns being 16 digit account numbers and valid Money
1. invalid account numbers will cause the program to exit with an error
1. the balance is read using Money and partial cents or negative values will
   cause the program to exit with an error
1. all currency is considered AUD and set in `lib/config.rb`
1. Money gem rounding is set to be explicitly `BigDecimal::ROUND_HALF_UP` but
   any partial values will cause the program to exit with an error
1. if there are no transfers the balances will just flow through and be output
   unaltered
1. taking a "simple solution" guiding principle this loads all the accounts
   into memory so it will have performance limitations if the file is too big,
   for the time being the account balance file is considered to be ok up to
   1,000,000 (1 million) accounts which sounds more than reasonable for all the
   accounts for a single company

   ```
   ruby -e '(0..1_000_000).each{|num| puts "123456%016d,10.00" % num }' \
     > large_account_balances.csv

   time bin/simple_banking_service.rb large_account_balances.csv  mable_trans.csv
   ~ 30 seconds
   ```

1. if the transfer has an account that does not exist in the provided account
   file the program will exit with an error
1. nothing wrong with transfers between same account, nothing should happen
1. taking a "fail fast" approach, any problem will cause an error, and the
   program will exit with an error code. This is preferred over "fail slow" as
   it is more work having to deal with partial errors. For example if only 1
   account was affected by a transfer that took the account below 0, should you
   apply the transfers? or not? I take the "fail fast" approach that it does
   not meet the needs of the program and hence should fail immediately.
1. Money can NEVER go below zero - this was not explicit in the initial
   instructions, for exampole if account X had +$10 and it needed to transfer
   -$11 but later get +$100 this would "fail fast" on the first transaction
   that took the balance below $0
1. only CSV will be supported
1. this is not actually the "banking service" just a simple verify script to
   show final balances and show that the transfers can be applied in a valid
   fashion
1. only customers that have a account balance in account balances are supported
1. no consideration is take for customers who are NOT in a processable state,
   they are invalid or inactive as there seems no way to tell that from the
   current data
1. limited work has been done to deal with wrong data
1. no way to know "which day" the transfers are actually being applied for,
   just taken as the files provided are the right files for the current time

## Extensions

- [ ] setup to run on docker to make it easier and safer to run
- [ ] extend to have more of a double ledger, at this point in time the
  transfers are just applied and not added to a ledger which could be confirmed
  that they have all been applied
- [ ] explore the possibility of splitting this up across separate processes,
  how would this work? could the transfers be applied separately and later
  joined?
- [ ] when and how could a caching layer be added? to look up the account and
  current balance? at the moment the account is stored in an array? maybe a
  hash would be fater?
- [ ] investigate storing the data in different stores, tree, database, Apache
  Arrow, Apache Parquet, other
- [ ] make the errors more friendly

## Retrospective

* writing quality software is hard
* spent a lot more time on the inital analysis and repository setup then I
  would have hoped or imagined but it was definitely worth thinking about the
  problem (3.5 hours rather than maybe 1.5 hours I would have hoped for)
* very happy with the size of commits and the way the work was split out
* spent a lot longer on getting an inital solution out then would have expected
  (6.5 hours rather than ~3 hours)
* would have been good to focus on some new libraries: validation with
  dry-validation or similar, or some variations on the boring approach: writing
  out a full ledger of all transactions maybe ¯\_(ツ)_/¯

* overall reasonably happy with the setup and the functionality of the code
* not too happy that the design could be easily extended for a different input
  format say if moving from CSV to JSON

## Work Log

- [x] finally completed a basic running version of the app, certainly ran out
  of time to do any real cool extensions but kept to the idea of "simple
  solution" 3 hours -> 12:00PM - 3:00PM

  in all this is **10 hours** work -> 3:30 + 3:30 + 3:00

- [x] basis for a simple solution, a pass through solution for account balances
  now works, but still no solution after 7 hours
    - 3:30 hours:minutes -> 8:30AM - 12:00PM
- [x] get a "simple solution" up and running, it's 3.5 hours in and I still
  have no code, look at a quick solution to meet a majority of the rubrick:
  `SimpleBankingService.run(file1, file2)` that reads in all `Accounts` and
  `Transfers` into memory, applies the transfers (or is this a separate class)
  and calls a `Reporter` on the `Accounts`
    - [x] look at failing fast if things don't work - just raise error
    - [x] limited validation for the moment, seems the files have no headers
    - [x] no smarts around the size of the processing
- [x] iteration 0 and analysis complete
    - 3:30 hours:minutes -> 10:30AM - 3:00PM - 1hour break
- [x] iteration 0
    - [x] setup build pipeline: rspec, rubocop, tool-version, make file, GitHub
      actions test runner?
        - [x] add a github action `.github/workfows/ci.yml`
        - [x] added make file
        - [x] add standard as a standard set of rubocop rules as per
            https://evilmartians.com/chronicles/rubocoping-with-legacy-bring-your-ruby-code-up-to-standard
        - [x] add rspec via `bundle add rspec` with defautls
        - [x] add ruby 3.2.2 (latest non preview) using
          [asdf](https://asdf-vm.com/)
    - [x] add a `make check-tools` to confirm that the right version of ruby
      etc are installed
    - [🔜] instructions for it to just work? would Docker be a better default
    - [x] an end to end test, say `spec/features`
    - [x] how to run this? and what is the output? maybe apply the "simple
      system" guiding principle and just create a unix terminal app in
      `bin/simple_banking_service.rb`
    - [x] a simple way to run it? say `make` as it is on every computer
- [x] how to meet expectations of the Rubrick
    - [x] uses domain models, hmm pull out the Domain Driven Design book and
      see how best to apply bounded contexts?
    - [x] idea of using native data structures, arrays, hashes? is there a need
      for anything more complicated?
    - [x] use rspec
    - [x] coverage? not a coverage report fan but might be an idea? my view is
      everything is covered by an outside in BDD test as well as a TDD unit
      test
    - [x] tests are orthogonal? pull out the dictionary - do we mean
      "orthogonal" asa synonmy for "independent" ie they don't crash if one
      thing breaks, they all break? in my BDD/TDD approach I would expect most
      of the time 2 tests to fail the outside in BDD describing what behaviour
      has broken and a TDD unit tests showing what causes that to break?
    - [x] tests explain the functionality Object Orientation - I presume there
      is a missing comma here? should be functionality, Object Orientation? ie
      if a FileParser returns an array of Account objects or if a debit 100
      occurs on an account with 10 an error is raised
    - [x] encapsulation, seperation of concerns, short methods, readable all
      the good things
    - [x] runs and provides feedback - error, success, output
    - [x] calculates test files accurately - presumably the provided files
      `mable_acc_balance.csv` and `mable_trans.csv`
- [x] anlyse the problem
    - [x] Daily CSV file with transfers
        - [x] how big?
        - [x] only CSV?
        - [x] how identified as daily?
    - [x] transfers they want to make between accounts for customers they are
      doing business with
        - [x] how to deal with customers they are NOT doing business with
        - [x] how to deal with customers they USED to do business with
        - [x] is there any chance of wrong data?
        - [x] what if the transfers were run for a historical date? where a
          customer is no longer on the "do business with list" is this a
          possiblitly?
    - [x] Accounts are identified by 16 digit number
        - [x] is this important? does it need validation? what if the account
          ID is not valid?
    - [x] money cannot be transferred from them that will put the account
      balance below $0
        - [x] is this just the ending balance? ie can Account X transfer
          negative during the day and end in positive?
    - [x] implement a simple system
        - [x] implement so code needs to be written
        - [x] "simple system" could be used as a guiding principle
    - [x] can load account balances for a single company
        - [x] how many balances is that? what would be a reasonable limit in
          terms of size?
    - [x] then accept a day's transfers in a CSV file
        - [x] again only CSV
        - [x] a "day's" transfer - how big? what is the limit?
        - [x] does "accept" a day's transfers mean "Actually calculate the
          remaining balances" or only "accpet" that the transfers do not go
          below $0? I am guessing a safe assumption is both? although this is
          not clear?
        - [x] also does "accept" mean this "simple banking service" is actually
          performing the transfers? clearly not as there is no banking API to
          move funds between accounts or simple saying the file provided is
          "acceptable" as in the accounts exist and nothing goes below 0 so it
          can be passed onto an actual banking app to perform the transfers?
    - [x] on size of balance and transfers
        - [x] what is considered reasonable?
        - [x] what is the limit on size of either file for memory/system
          resources and time?
    - [x] example files provided would result in a balance (as calculated by
      hand)

        | Account          | Balance   | Calculations     |
        | :--------------- | --------: | :--------------- |
        | 1111234522226789 |   4820.50 | -500 + 320.50    |
        | 1111234522221234 |   9974.40 | - 25.60          |
        | 2222123433331212 |   1550.00 | + 1000           |
        | 1212343433335665 |   1725.60 | + 500 + 25.60    |
        | 3212343433335755 |  48679.50 | - 1000 - 320.50  |

    - [x] probably should use a Money library like the Money gem
    - [x] doing the manual calclations above kind of resembles a double entry
      ledger, where every calculation has an associated debit and credit
        - [🔜] might be good to represent this in the modelling of the problem
        - [x] presumably a debit and credit have to happen a the same time in a
          sort of transaction or not happen at all
        - [x] every transaction should happen only once, so may need to make
          sure they are idempotent, maybe by line number in the CSV? or could
          build out a sort of ledger like a cheap version of a blockchain,
          where the MD5 hash of the previous transactions need to be calculated
          prior to pefrorming the next transaction? not sure if that sits with
          "Simple system" but sounds like fun 👨‍💻
        - [🔜] could the transactions ever be split into separate threads?
          workers? asynchronous jobs to scale and process quickly?
        - [🔜] would there be any value in adding a caching layer at any point,
          in case files are too large?
        - [🔜] would other technology choices like a database or something like
          Apache Arrow (in-memory analytics) have benefits here? I did a tech
          talk at RORO meetup - 120X faster than ruby CSV

          [![Data pipelines in Rails and Postgres - Micheal Millewski
            ](http://img.youtube.com/vi/cCm7-zagbwY/0.jpg)
            ](https://youtu.be/cCm7-zagbwY?t=1203s)

          and was actually recently mentioned at RubyKaigi Matsumoto Japan in a
          talk about ADBC Arrow DataBase Connectivity slides available on
          https://www.clear-code.com/blog/2023/5/15/rubykaigi-2023.html
        - [x] this also brings up a question of if it is better to tackle this
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

