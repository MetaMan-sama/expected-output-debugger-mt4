//+------------------------------------------------------------------+
//|                          DebuggingTool.mq4                       |
//|   Logs detailed information about trades, indicators, and errors |
//+------------------------------------------------------------------+
#property strict

// Input parameters
input string LogFileName = "DebugLog.txt"; // Name of the log file
input bool LogToFile = true;               // Save logs to a file
input bool LogTradeDetails = true;         // Log trade information
input bool LogIndicatorValues = true;      // Log indicator values
input bool LogErrors = true;               // Log errors

//+------------------------------------------------------------------+
//| Main Function                                                   |
//+------------------------------------------------------------------+
void OnStart()
{
   Print("Debugging Tool Started.");
   
   // Log open trades
   if (LogTradeDetails) {
      LogTrades();
   }

   // Log indicator values
   if (LogIndicatorValues) {
      LogIndicators();
   }

   // Test error handling and logging
   if (LogErrors) {
      TestErrorLogging();
   }

   Print("Debugging Tool Completed.");
}

//+------------------------------------------------------------------+
//| Log details of all open trades                                  |
//+------------------------------------------------------------------+
void LogTrades()
{
   string log = "Trade Details:\n";

   for (int i = 0; i < OrdersTotal(); i++) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         log += StringFormat(
            "Ticket: %d, Symbol: %s, Type: %s, Lots: %.2f, OpenPrice: %.5f, Profit: %.2f\n",
            OrderTicket(),
            OrderSymbol(),
            OrderType() == OP_BUY ? "Buy" : "Sell",
            OrderLots(),
            OrderOpenPrice(),
            OrderProfit()
         );
      }
   }

   Print(log);
   if (LogToFile) WriteToFile(log);
}

//+------------------------------------------------------------------+
//| Log indicator values                                             |
//+------------------------------------------------------------------+
void LogIndicators()
{
   string log = "Indicator Values:\n";
   string symbol = Symbol();
   int period = PERIOD_CURRENT;

   // Example: Moving Average
   double maValue = iMA(symbol, period, 14, 0, MODE_SMA, PRICE_CLOSE, 0);
   log += StringFormat("Moving Average (14 SMA): %.5f\n", maValue);

   // Example: RSI
   double rsiValue = iRSI(symbol, period, 14, PRICE_CLOSE, 0);
   log += StringFormat("RSI (14): %.2f\n", rsiValue);

   Print(log);
   if (LogToFile) WriteToFile(log);
}

//+------------------------------------------------------------------+
//| Test error logging                                              |
//+------------------------------------------------------------------+
void TestErrorLogging()
{
   int fakeTicket = -1;
   if (!OrderSelect(fakeTicket, SELECT_BY_TICKET)) {
      string error = StringFormat("Error selecting order: %d. Error Code: %d\n", fakeTicket, GetLastError());
      Print(error);
      if (LogToFile) WriteToFile(error);
   }
}

//+------------------------------------------------------------------+
//| Write log to file                                               |
//+------------------------------------------------------------------+
bool WriteToFile(string content)
{
   string filePath = TerminalInfoString(TERMINAL_DATA_PATH) + "\\MQL4\\Files\\" + LogFileName;

   int handle = FileOpen(filePath, FILE_WRITE | FILE_TXT | FILE_COMMON);
   if (handle == INVALID_HANDLE) {
      Print("Failed to open log file: ", GetLastError());
      return false;
   }

   FileWrite(handle, content);
   FileClose(handle);
   return true;
}
