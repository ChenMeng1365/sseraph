var electron = require('electron');
var app = electron.app;
var BrowserWindow = electron.BrowserWindow;
var mainWindow = null;
var globalShortcut = electron.globalShortcut;

app.on('ready',()=>{
    // 新建主窗口
    mainWindow = new BrowserWindow({
        width:1600, 
        height:900,
        webPreferences: {nodeIntegration: true}
    });

    // 调试模式
    mainWindow.webContents.openDevTools(); 

    // 设置菜单
    require('./render/menu.js');

    // 注册全局快捷键
    globalShortcut.register('Ctrl+e',()=>{
        mainWindow.loadURL('https://www.baidu.com')
    });
    let isRegistered = globalShortcut.isRegistered('Ctrl+e') ? 'Registry success!' : 'Registry fail!';
    console.log(isRegistered); // 检查注册是否失败

    // 载入主页面
    mainWindow.loadFile('index.html');

    // 嵌入网页
    // var BrowserView = electron.BrowserView;
    // var view = new BrowserView();
    // mainWindow.setBrowserView(view);
    // view.setBounds( {x:0, y:100, width:800, height: 600});
    // view.webContents.loadURL('http://mathstud.io/');

    // 关闭时注销主窗口
    mainWindow.on('closed',()=>{
        mainWindow = null;
    });
});

// 关闭时注销全局快捷键
app.on('will-quit', function(){
    // 取消快捷键注册
    globalShortcut.unregister('Ctrl+e');
    globalShortcut.unregisterAll();
    console.log('All registers are unregistried!');
});
