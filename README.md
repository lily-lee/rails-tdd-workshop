# TDD Workshop

[![Build Status](https://travis-ci.com/lily-lee/rails-tdd-workshop.svg?branch=master)](https://travis-ci.com/lily-lee/rails-tdd-workshop)

# 资料

[深度解读 - TDD（测试驱动开发）](https://www.jianshu.com/p/62f16cd4fef3)

JSON:API 规范

http://zyzhang.github.io/blog/2013/04/28/test-pyramid/

https://ruby-china.github.io/rails-guides/routing.html

https://jsonapi.org/

https://github.com/JuanitoFatas/ruby-style-guide/blob/master/README-zhCN.md

https://github.com/JuanitoFatas/rails-style-guide/blob/master/README-zhCN.md

https://github.com/rubocop-hq/rspec-style-guide


# 步骤

## 2019.01.16

1. 初始化一个rails项目

```bash
$ rails new tdd-workshop --database=postgresql --skip-active-storage --skip-coffee -T -B
```


2. 修改Gemfile，安装依赖

```bash
$ bundle install
```


3. 数据库设置
```
bundle exec rails db:migrate && rails db:setup
```


4. add rubocop config and rake task

add .rubocop.yml

update Rakefile

add lib/tasks/rubocop.rake


5. generate rspec file and config it

```
rails generate rspec:install
```

6. config to not generate the files which will not be used

update config/application.rb 


7. add controller home#index as route, add spec

```
$ rails g controller home index
```


8. add .travis.yml



## 2019.01.23


