// JS没有现成的sleep(), 需要自己实现

// 1. 通过死循环定时
// 要点: while(new Date().getTime()<endTime){do_something_waste_time()}
// 缺点: sleep执行过程中其他代码会停止运行, DOM渲染也会暂停

function sleep(time) {
  var timeStamp = new Date().getTime();
  var endTime = timeStamp + time;
  while (true) {
    if (new Date().getTime() > endTime) {
      return;
    }
  }
}
console.time('runTime:');
sleep(2000);
console.log('1');
sleep(3000);
console.log('2');
sleep(2000);
console.log('3');
console.timeEnd('runTime:');

// 2. 通过回调实现定时
// 要点: setTimeout(function(){...}, time)
// 缺点: 回调的方式在多个事务执行时, 会出现嵌套现象

console.time('runTime:');
setTimeout(function () {
  console.log('1')
  setTimeout(function () {
    console.log('2');
    setTimeout(function () {
      console.log('3');
      console.timeEnd('runTime:');
    }, 2000);
  }, 3000);
}, 2000);

// 3. Promise
// 要点: sleep(time){return new Promise(action){setTimeout(action, time)}} && sleep(time).then(function(){action()})
// 缺点: 仍然有嵌套结构, 回调是在参数上嵌套, Promise是在调用链上嵌套

function sleep(time) {
  return new Promise(function (resolve) {
    setTimeout(resolve, time);
  });
}
console.time('runTime:');
console.log('1');
sleep(1000).then(function () {
  console.log('2');
  sleep(2000).then(function () {
    console.log('3');
    console.timeEnd('runTime:');
  });
});
console.log('a');

// 4. Generator
// 要点: 利用生成器自动执行Promise对象 co(function *run(){... yield sleep(time) ...})
// 缺点: 一个生成器函数+一个co()调用=麻烦, 现在co已经很少用了

var co = require('co');

function sleep(time) {
  return new Promise(function (resolve) {
    setTimeout(resolve, time);
  });
}

var run = function* () {
  console.time('runTime:');
  console.log('1');
  yield sleep(2000);
  console.log('2');
  yield sleep(1000);
  console.log('3');
  console.timeEnd('runTime:');
}

co(run);
console.log('a');

// 5. async
// 要点: async自带执行器 async function run(){... await sleep(time) ...} => run()
// 缺点: 仍是生成器

function sleep(time) {
  return new Promise((resolve) => setTimeout(resolve, time));
}

async function run() {
  console.time('runTime:');
  console.log('1');
  await sleep(2000);
  console.log('2');
  await sleep(1000);
  console.log('3');
  console.timeEnd('runTime:');
}

run();
console.log('a');

// 6. 使用sleep包
// 要点: 使用线程的sleep包
// 缺点: 依赖

var sleep = require('sleep');

console.log('1');
console.time('runTime:');
sleep.sleep(2); //休眠2秒钟
console.log('2');
sleep.msleep(1000); //休眠1000毫秒
console.log('3');
sleep.usleep(1000000) //休眠1000000微秒 = 1秒
console.log('4');
console.timeEnd('runTime:');

// 7. 子进程
// 要点: 使用execFileSync或spawnSync派生同步进程, 定时器执行完成后回收
// 缺点: 多进程, 较复杂

var childProcess = require('child_process');
var nodeBin = process.argv[0];

function sleep(time) {
  childProcess.execFileSync(nodeBin, ['-e', 'setTimeout(function() {}, ' + time + ');']);
  // childProcess.spawnSync(nodeBin, ['-e', 'setTimeout(function() {}, ' + time + ');']);
}

console.time('runTime:');
console.log('1');
sleep(1000);
console.log('2');
sleep(2000);
console.log('3');
console.timeEnd('runTime:');