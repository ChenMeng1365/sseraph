var {shell} = require('electron');

var exlink = document.querySelector('#exlink');
exlink.onclick = function(e){
    e.preventDefault();
    var href = this.getAttribute('href');
    shell.openExternal(href);
};

var exwin = document.querySelector('#exwin');
exwin.onclick = function(e){
    window.open('http://mathstud.io/');
};


