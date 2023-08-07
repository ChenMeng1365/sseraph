const {Menu, BrowserWindow} = require('electron');
var template = [
    {
        label: "菜单名",
        submenu: [
            {label: "选项1"},
            {label: "选项2"}  
        ]
    },
    {
        label: "新增练习",
        submenu: [
            {
                label: "新开窗口",
                accelerator: "ctrl+n",
                click: ()=>{
                    var win = new BrowserWindow({
                        width:640, 
                        height:480,
                        webPreferences: {nodeIntegration: true}
                    });
                    win.loadFile('remote.html');
                    win.on('closed',()=>{
                        win = null
                    });
                }
            },
            {
                label: "外部链接",
                accelerator: "ctrl+e",
                click: ()=>{
                    var win = new BrowserWindow({
                        width: 800,
                        height: 600,
                        webPreferences: {nodeIntegration: true}
                    });
                    win.loadFile('exlink.html');
                    win.on('closed',()=>{
                        win = null
                    });
                }
            }  
        ]
    }
];

var menu = Menu.buildFromTemplate(template);
Menu.setApplicationMenu(menu);