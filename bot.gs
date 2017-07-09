function postGoroku(channel) {
  const CURRENT_SHEET_NAME = PropertiesService.getScriptProperties().getProperty('CURRENT_SHEET_NAME');

  var spreadsheet = SpreadsheetApp.getActiveSpreadsheet();
  var sheet = spreadsheet.getSheetByName(CURRENT_SHEET_NAME);
  var lastRow = sheet.getLastRow();

  var randomRow = Math.floor(Math.random() * lastRow) + 1;

  var rows = sheet.getSheetValues(randomRow, 1, 1, 1);

  postSlackMessage(channel, rows[0][0]);
};

function addGoroku(channel, goroku) {
  const CURRENT_SHEET_NAME = PropertiesService.getScriptProperties().getProperty('CURRENT_SHEET_NAME');

  var spreadsheet = SpreadsheetApp.getActiveSpreadsheet();
  var sheet = spreadsheet.getSheetByName(CURRENT_SHEET_NAME);
  var lastRow = sheet.getLastRow();
  
  var cell = sheet.getRange(lastRow + 1, 1).setValue(goroku);

  postSlackMessage(channel, "語録追加done");
};

function searchGoroku(channel, keyword) {
  const CURRENT_SHEET_NAME = PropertiesService.getScriptProperties().getProperty('CURRENT_SHEET_NAME');

  var spreadsheet = SpreadsheetApp.getActiveSpreadsheet();
  var sheet = spreadsheet.getSheetByName(CURRENT_SHEET_NAME);
  var lastRow = sheet.getLastRow();
  
  var cells = sheet.getSheetValues(1, 1, lastRow, 1);
  
  var matchedRows = [];
  var pattern = new RegExp(keyword);
  
  for (var row = 0; row < lastRow; row++) {
    var cell = cells[row][0].toString();

    if (cell.match(pattern) !== null) {
      matchedRows.push(cell);
    }
  }

  var searchResult = (matchedRows.length === 0) ? "検索してもなかったよ" : "検索したら" + matchedRows.length + "件あったよ\n" + matchedRows.join("\n");
  
  postSlackMessage(channel, searchResult);

};

function doPost(e) {
  var channel  = e.parameter.channel_id;
  var text     = e.parameter.text;
  var userName = e.parameter.user_name;
  
  var botName = PropertiesService.getScriptProperties().getProperty('BOT_NAME');

  if (botName == userName) {
    return;
  }
  
  var commands = text.replace(/　/g, " ").split(/\s+/);

  switch(commands.length) {
    case 1:
      if (commands[0] === "語録" || commands[0] === "goroku") {
        postGoroku(channel);
      }
      break;
    case 2:
      if (commands[1] === "help" || commands[1] === "ヘルプ") {
        postSlackMessage(channel, "ヘルプだよ");
      }
    case 3:
      if (commands[1] === "add" || commands[1] === "追加") {
        addGoroku(channel, commands[2]);            
      }
      if (commands[1] === "search" || commands[1] === "検索") {
        searchGoroku(channel, commands[2]);
      }
      break;
    default:
      postSlackMessage(channel, "( ˘ω˘)ｽﾔｧ");
      break;
  }
}

function postSlackMessage(channel, message) {
  var token   = PropertiesService.getScriptProperties().getProperty('SLACK_ACCESS_TOKEN');
  var botName = PropertiesService.getScriptProperties().getProperty('BOT_NAME');
  var botIcon = PropertiesService.getScriptProperties().getProperty('BOT_ICON');
  
  var app = SlackApp.create(token);
  
  return app.postMessage(channel, message, {
    username: botName,
    icon_url: botIcon
  });
}
