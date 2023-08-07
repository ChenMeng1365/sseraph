
### vue-cli

```
# 安装vue-cli工具
cnpm install -g vue-cli
vue -V

# 配置环境
mkdir <dir>
cd <dir>
vue init webpack <project>
# 选项自定义
>Runtime-only | Runtime + Compiler [select]
>vue-router [y]
>ESLint [n] | [y] > Standard [select]
>unit tests [n] | [y] > Jest |Karma and Mocha [any]
>e2e tests [n] | [y] > Nightwatch
>handle that myself [select]
npm install # 不要用cnpm install

# 开发
cd <project>
npm run dev   # => listen on http://localhost:8080/
npm run build # => /dist
```
