var fs = require('fs');

window.onload = function(){
    var load_btn = this.document.querySelector("#load_btn");
    var file = this.document.querySelector("#file");
    load_btn.onclick = function(){
        fs.readFile('flamutt.txt',(err,data)=>{
            file.innerHTML = data;
        });
    };

    const remote_btn = this.document.querySelector('#remote_btn');
    const BrowserWindow = require('electron').remote.BrowserWindow;
    remote_btn.onclick = ()=>{
        newWindow = new BrowserWindow({
            width: 800,
            height: 600
        });
        newWindow.loadFile('remote.html');
        newWindow.on('close',()=>{
            newWindow = null;
        });
    };

    var exlink_btn = document.querySelector('#exlink_btn');
    exlink_btn.onclick = function(e){
        var win = new BrowserWindow({
            width: 800,
            height: 600,
            webPreferences: {nodeIntegration: true}
        });
        win.loadFile('exlink.html');
        win.on('closed',()=>{
            win = null
        });
    };

    var subwin_btn = document.querySelector('#subwin_btn');
    subwin_btn.onclick = function(e){
        window.open('subwin.html');
    };

    const {dialog} = require('electron').remote;
    var sfile_btn = document.querySelector('#sfile_btn');
    sfile_btn.onclick = function(e){
        dialog.showOpenDialog({
            title: 'Please select file',
            defaultPath: "pic.jpg",
            filters: [{name: 'img',extensions:['jpg','png']}],
            buttonLabel: '加载'
        }).then(result=>{
            // console.log(result);
            let image = document.querySelector('#image');
            image.setAttribute('src',result.filePaths[0]);
        }).catch(error=>{
            console.log(error);
        });
    };

    var wfile_btn = document.querySelector('#wfile_btn');
    wfile_btn.onclick = function(e){
        dialog.showSaveDialog({
            title: "Save the file"
        }).then(result=>{
            console.log(result);
            fs.writeFileSync(result.filePath,'context');
        }).catch(error=>{
            console.log(error);
        });
    };

    var msgbox_btn = document.querySelector('#msgbox_btn');
    msgbox_btn.onclick = function(e){
        dialog.showMessageBox({
            type: 'warning',
            title: 'FBI Warning',
            message: 'Are you ok?',
            buttons: ['Yes,indeed.','No, thanks.']
        }).then(result=>{
            console.log(result);
        }).catch(error=>{
            console.log(error);
        });
    };
}

var rclickTemplate = [
    {
        label: "复制",
        accelerator: "c"
    },
    {
        label: "粘贴",
        accelerator: "v"
    }
]
const {remote} = require('electron');
var rclickmenu = remote.Menu.buildFromTemplate(rclickTemplate);

window.addEventListener("contextmenu",function(e){
    e.preventDefault()
    rclickmenu.popup({window: remote.getCurrentWindow()})
});

window.addEventListener('message',(msg)=>{
    let sub_channel = document.querySelector('#sub_channel');
    sub_channel.innerHTML = JSON.stringify(msg);
});