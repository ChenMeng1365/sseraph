
### vue project 项目解析

* src/main.js生成全局实例new Vue({...})
* src/App.vue是全局组件，改写它全局都会改变
* src/components/xxx.vue是单个组件的构建，分成template、script、style三部分设置
* src/router/index.js设置路由，要修改路由只需要修改routes数组的成员，同时import相应的组件

* 组件中<template/>元素必须含有一个基本的<div/>作为根元素来代表当前页面渲染的对象，不可有其他平级元素

* 使用{mode: 'history'}定义经典URL模式，使用{mode: 'hash'}定义带#的URL模式
* 定义子路由时，在{routes: [ {...}]}的父路由中追加children:{...}选项，单独定义子路由
* 子路由的path前置可以用绝对路径写法，如/a/b/c/sub，或者用相对路径，如直接写sub，不要在相对路径前加/
* 路由的path通过$route.path来获取，name可以通过$route.name来获取
* name是可以随便命名的，没有强制规则
* 父路由/a/b/c的name在子路由定义了'/'或''（绝对路径都是/a/b/c）的name后将被覆盖，如果父路由将作为子路由生效，同时组件会被渲染两次
* 使用{path:'*'}定义404页面，再关联一个用于404的组件
* 路由可以通过{redirect: URL}选项直接跳转，不需要引用组件，包括由参数字段构成的URL都可以
* 路由可以通过{alias: URL}选项给予跳转链接别名，直接使用别名链接实现页面转变但可以保持{path: URL}不变
* 组件内使用this.$router.push('URL')进行跳转，this.$router.go(-1)表示后退，this.$router.go(1)表示前进

* <router-link to="route.path"></router-link>相当于<a>标签,to属性指某页面路由的绝对路径
* <router-link :to="{name: route.name, params: {'k':v}"/>可以接受绑定路由的名称选择路由，同时可以接受params接受参数，参数通过$route.params.k来获取值(注意k是字符串)

* <router-view></router-view>是嵌套视图声明，对/a/b/c渲染，其下的子路由/a/b/c/x会接到视图传递，即渲染到/a/b/c/x时，加载/a/b/c的渲染
* <router-view name="route.comname"/>可以为一个组件指定多个其他组件渲染的页面，多个<router-view/>存在时只有一个可以不写名称
* <router-view style="style-list"/>可以指定声明视图的渲染样式，注意是在声明处而不是在组件内部

* 组件的渲染顺序是根路由的全局组件==>父路由的组件==>子路由的组件，哪怕父组件没有内容也要指定，否则子路由的组件不会渲染
* 路由中指定单个组件时使用component: comname，指定多个组件时，路由的组件要用components: {default: xxx, comname: yyy, ...}

* 除了指定URL参数外，对于参数字段构建URL也可以通过$route.params来获取，如声明路由/a/:b/:c，组件中可以通过$route.params.b和$route.params.c来获取
* 字段参数URL还可以使用'(...)'的正则表达式声明变量的格式，以支持某一类的路由的字段名称，如/a/:b(\\w+\\d+)/:c，表示参数b是由字母开头数字收尾的字符串组成的

* 加载页面淡入淡出效果
```
<div>
  <transtion name='xxx' mode='in-out'> <!-- in-out先in后out out-in先out后in -->
    <router-view/>
  </transtion>
</div>
<style>
.xxx-enter{
  opacity: 0;
}
.xxx-enter-active{
  -webkit-transition:opacity .5s;
}
.xxx-leave{
  opacity: 1;
}
.xxx-leave-active{
  opacity: 0;
  -webkit-transition:opacity .5s;
}
</style>
```

* 路由的钩子选项
```
beforeEnter: (to,from,next)=>{
  console.log(to);
  console.log(from);
  next(true); // true或空跳转，false或无next()不跳转，{path: '...'}跳转到其他路径
}
类似的有beforeLeave
```

* 组件script中设置钩子方法
```
beforeRouteEnter: (to,from,next)=>{
  console.log(to);
  console.log(from);
  next(true); // true或空跳转，false或无next()不跳转，{path: '...'}跳转到其他路径
}
类似的有beforeRouteLeave
```
