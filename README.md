# Expected Output Debugger — MQL4 Script

A MetaTrader 4 diagnostic utility script that performs **structured runtime validation** of open trade state, live indicator snapshots, and error-handling infrastructure by executing three independently gated diagnostic routines — `LogTrades()`, `LogIndicators()`, and `TestErrorLogging()` — routing all output to both the MT4 Experts tab and an optional sandbox log file via `WriteToFile()` using `FileOpen()` with `FILE_WRITE | FILE_TXT | FILE_COMMON`, designed for validating expected EA output against actual runtime state during development and debugging workflows.

---

## Overview

The Expected Output Debugger is a structured validation companion for MQL4 Expert Advisor development. Unlike a general-purpose debugger, its design philosophy centres on confirming **expected vs actual** runtime output: open trade logs verify order state matches what the EA should have produced; indicator snapshots confirm signal calculation values align with manual expectations; and the error logging test validates that the EA's error-capture infrastructure catches and records `GetLastError()` codes correctly. All three routines can be independently enabled or disabled via boolean input flags, and all output is formatted consistently — making it straightforward to compare Experts tab output against a reference log file from a prior validated run.

---

## Features

- **Open trade state validator** — `LogTrades()` iterates all `OrdersTotal()` positions via `OrderSelect(i, SELECT_BY_POS, MODE_TRADES)`, building a formatted string per order: ticket, symbol, type (Buy/Sell string resolved from `OrderType() == OP_BUY`), lot size, open price, and running profit
- **Live indicator snapshot** — `LogIndicators()` computes `iMA(symbol, PERIOD_CURRENT, 14, 0, MODE_SMA, PRICE_CLOSE, 0)` and `iRSI(symbol, PERIOD_CURRENT, 14, PRICE_CLOSE, 0)` for the active symbol, logging both with consistent decimal precision for repeatable comparison
- **Error infrastructure validation** — `TestErrorLogging()` deliberately calls `OrderSelect(-1, SELECT_BY_TICKET)` to generate a controlled `GetLastError()` response, verifying the capture path and optional `WriteToFile()` error-write route both function correctly
- **Sandbox file output** — `WriteToFile()` constructs the full path via `TerminalInfoString(TERMINAL_DATA_PATH) + "\\MQL4\\Files\\" + LogFileName`, opens with `FILE_WRITE | FILE_TXT | FILE_COMMON`, writes content via `FileWrite()`, and returns `false` with a `GetLastError()` print on `INVALID_HANDLE`
- **Three independent diagnostic gates** — `LogTradeDetails`, `LogIndicatorValues`, `LogErrors` boolean flags enable selective routine execution without source modification

---

## How It Works

1. `OnStart()` prints startup confirmation, then evaluates three boolean gates sequentially
2. `LogTrades()` → `LogIndicators()` → `TestErrorLogging()` each run if their respective flag is `true`
3. Each routine builds a `string log` via `StringFormat()` accumulation, calls `Print(log)`, and calls `WriteToFile(log)` if `LogToFile == true`
4. `WriteToFile()` opens `LogFileName` in the MT4 Files sandbox, writes content, closes the handle, and returns success/failure boolean with error code on failure

---

## Input Parameters

| Parameter             | Type   | Default           | Description                                                            |
|-----------------------|--------|-------------------|------------------------------------------------------------------------|
| `LogFileName`         | string | `DebugLog.txt`    | Filename for optional log output written to the MT4 Files sandbox      |
| `LogToFile`           | bool   | `true`            | Route all diagnostic output to the log file in addition to Experts tab |
| `LogTradeDetails`     | bool   | `true`            | Enable open trade enumeration and state logging                        |
| `LogIndicatorValues`  | bool   | `true`            | Enable live SMA and RSI indicator snapshot logging                     |
| `LogErrors`           | bool   | `true`            | Enable controlled `OrderSelect(-1)` error validation test              |

---

## Output File Location

```
%APPDATA%\MetaQuotes\Terminal\<TerminalID>\MQL4\Files\DebugLog.txt
```

---

## Installation

1. Copy `Expected_Output_001.mq4` to `MQL4/Scripts/` in your MT4 data folder
2. Compile in MetaEditor (F7)
3. Drag onto any chart from Navigator → Scripts
4. Configure inputs and click **OK**
5. Compare Experts tab output and log file against your expected reference values

---

## Requirements

- MetaTrader 4 (`#property strict` compatible build)
- MQL4 compiler (MetaEditor)

---

## License

MIT License

Copyright (c) 2026

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
