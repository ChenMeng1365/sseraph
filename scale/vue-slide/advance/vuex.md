
### vuex

先正常建立一个项目，然后在项目目录下执行
```
cnpm install vuex --save
```
确认package.json中已经加入了vuex

### note

vuex主要用于多页面缓存数据，正常向后端请求数据推荐用axios

### 使用

1. 指定路径下生成数据模型文件比如model.js，导入vuex
```
import Vue from 'vue';
import Vuex from 'vuex';
Vue.use(Vuex);
```

2. 定义数据对象，然后发布出去，这里的对象都是不可变值
```
const const_name_1 = {
  k: v, ...
};
...
export default new Vuex.Store({
  const_name_1,
  const_name_2,
  ...
});
```

有四类state、mutations、actions、getters常用对象：
* state用于保存单一状态值
* mutations和actions用于设置操作state的方法，差异在于mutations只做定义而actions兼具执行context.commit()，写法和调用方法不同，此外actions还是异步执行的
* getters用于对复杂state子对象查询做简单计算再获取值

3. 在组件中引入数据模型，代码中使用$model.const_name.property_name来引用数据
```
import model from '路径'
```

4. 在组件中直接使用数据对象的几种快捷方法，主要涉及数据对象名称的查询
方法一：直接使用$
```
  computed: {
    property_name(){
      return this.$model.const_name.property_name;
    }
  },
```

方法二：使用mapState简化操作
```
// 组件中要先引入mapState
import {mapState} from 'vuex';

// a.为mapState绑定对象，使用quick_name检索即可
  computed: mapState({
    quick_name: state => const_name.property_name
  }),

// b.为mapState绑定对象，使用quick_name检索即可，和上一种方式是等效的
  computed: mapState({
    quick_name: function(state){
      return const_name.property_name;
    }
  }),

// c.为mapState绑定对象，简写方式，不过数据名称要完全一致
  computed: mapState(['property_name',...]),
```

5. mapMutations对于数据操作方法的使用方法类似：

方法一：定义了mutations后，直接调用
```
// 定义
const mutations = {
  method_name(state,args...){
    ...
  },
}
// 调用
import {mapMutationss} from 'vuex';
$model.commit("method_name",args...) # mutations的method默认第一个参数是state，args是从第二个参数开始
```

方法二：组件中注册多个方mutations方法名，直接使用方法名，不再需要前缀定位
```
import {mapMutationss} from 'vuex';
// 注册
  methods: mapMutations(['method_name',...])
// 调用
method_name # 可以不要括号
```

6. mapGetters对于数据操作方法的使用方法类似：
```
// 定义
const getters = {
  process_name: function(state){
    ...
  }
}
// 设置及调用
import {mapGetters} from 'vuex';
export default {
  ...
  
  computed: {
    ...XXX, // 使用ES6 ...方式扩展原本设置
    // a.写法1
    alias_name(){
      return this.$model.getters.process_name;
    }
    // b.写法2
    ...mapGetters(["process_name",...])
  },
  ...
}
写法1直接使用alias_name即可，写法2直接使用process_name
```

7. mapActions对于数据操作方法的使用方法类似：
```
// 定义
const actions = {
  call_name(context,args...){
    context.commit('method_name',args...); // method_name是mutations中设置的方法，所以mutations也要使用
  },
  call_name({commit},args...){
    commit('method_name',args...);  // 另一种写法
  }
}
// 设置及调用
import {mapActions} from 'vuex';
export default {
  ...
  computed: {
    ...mapActions(["call_name",...])
  },
  ...
}
直接使用call_name即可
```

8. 模块组用于定制模块方法，除非项目巨大，不推荐使用
```
// 定义
const module = {
  const_name, ...
}
export default new Vuex.Store({
  modules: {module_name: module, ...}
})
// 直接调用$model.const_name.module_name.property_name，或者
  computed: {
    ...
    alias_name(){
      return this.$model.const_name.module_name.property_name;
    }
  }
// 包装过后，可以直接使用alias_name
```

