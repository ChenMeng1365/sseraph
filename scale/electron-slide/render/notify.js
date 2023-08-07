
var notify_btn = document.querySelector('#notify_btn');
var content = {
    title: '点击消息',
    body: '这是一个点击消息通知'
};
notify_btn.onclick = function(){
    new window.Notification(content.title,content);
};

window.addEventListener('online',function(){
    new window.Notification('网络连通',{title: '网络连通',body: '网络连通'});
});
window.addEventListener('offline',function(){
    new window.Notification('网络断开',{title: '网络断开',body: '网络断开'});
});