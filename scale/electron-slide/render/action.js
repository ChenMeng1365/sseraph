const {clipboard} = require('electron');
const context = document.getElementById('context');
const copy_btn = document.getElementById('copy_btn');
copy_btn.onclick = function(){
    clipboard.writeText(context.innerHTML);
    alert('复制成功');
}