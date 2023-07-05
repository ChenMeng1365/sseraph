#coding:utf-8
begin
# 官方文档地址：http://api.rubyonrails.org/classes/ActiveRecord/Base.html
# 关联：http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html

=begin
create table users(
   id int auto_increment primary key,
   username varchar(20),
   password varchar(20)
);
=end

class User < ActiveRecord::Base
  set_table_name "users"
  self.table_name = "users"
  set_primary_key "id"

  def password=(value)
    raise "密码不能空!" if value.nil? or value.empty?
    wirte_attribute "password",value
  end
  
  # private:
  # write_attribute()
  # read_attribute()
end

#### CRUD ####

# create 
u = User.new
u.username='lock'
u.password='123456'
u.save

User.create(:username=>'yea',:password=>'123456')
User.create([{:username=>'name1',:password=>'123'},{:username=>'name2',:password=>'456'}])
User.create(:username=>'yee') do |u|
  u.password='123456'
end

# read
#根据主键查找记录,如果没有记录则会抛出RecordNotFound的异常
User.find(1)
User.find(1,2,3)
User.find([1,2,3])

Person.find(:first) # returns the first object fetched by SELECT * FROM people
Person.find(:first, :conditions => [ "user_name = ?", user_name])
Person.find(:first, :conditions => [ "user_name = :u", { :u => user_name }])
Person.find(:first, :order => "created_on DESC", :offset => 5)
Person.find(:last) # returns the last object fetched by SELECT * FROM people
Person.find(:last, :conditions => [ "user_name = ?", user_name])
Person.find(:last, :order => "created_on DESC", :offset => 5)
Person.find(:all) # returns an array of objects for all the rows fetched by SELECT * FROM people
Person.find(:all, :conditions => [ "category IN (?)", categories], :limit => 50)
Person.find(:all, :conditions => { :friends => ["Bob", "Steve", "Fred"] })
Person.find(:all, :offset => 10, :limit => 10)
Person.find(:all, :include => [ :account, :friends ])
Person.find(:all, :group => "category")
=begin
:conditions参数类似于SQL中的WHERE子句，指定查询中的条件。
:order 对返回的结果排序，类似于SQL中的ORDER BY
:group 分组，类似SQL中的 GROUP BY
:limit 指定返回结果的行数
:offset 指定结果的偏移量，表示从第几条符合条件的记录开始
:joins 类似于LEFT JOIN之类的自子语句，详情参阅官方文档
:include 根据表之间的关联，在查询中自动加入LEFT OUTER JOIN的SQL语句，详情参阅官方文档
:select 返回的字段，以字符串形式表示，如"id,name"。默认为select * ...
:from SELECT语句from后面的表名，默认为当前模型对应的表，可根据需要指定其他的表或视图
:readonly 标记返回的记录为只读，不能再被更细或保存
:lock 如：:lock=>true  一个排它锁，通常用于在生产的sql语句中包含 for update子句,这样只有在事务提交后，锁才会被释放。
=end

users = User.find_by_sql(
  [
    'select * from users where username=?and password=?',
    username,
    password
  ]
)

users = User.find_by_username('jack')
users = User.find_by_password('123456')

# update
#给查询的对象重新赋值
u = User.find(1)
u.username = 'ttt'
u.save

#使用update_attribute()可以同时更新给定的特定字段的值,这种形式不再需要调用save方法
u = User.find(1)
u.update_attribute(:username=>'newname',:password=>'321654')

#使用类方法，update()和update_all(),update的第一个参数为更新的id。
User.update(1,:username=>'john',:password=>'123456')#更新ID为1的记录的username为john，password为123456
User.update_all("password='123'","username like '%j%'")#更改所有用户中用户名包含j的密码为123

# delete
#第一种，调用对象的destroy方法
u = User.find(1)
u.destroy

#第二种，类方法delete()
User.delete(1)
User.delete([1,2,3])

#第三种,类方法delete_all()，它类似于SQL语句中DELETE语句的where
User.delete_all("username like '%j%'")


#### 表间的关联 ####
=begin
两表之间可能的关联分为三种：
1. 一对一关系
2. 一对多关系
3. 多对多关系
ActiveRecord提供了4个方法来表示表之间的关联：
has_one、has_many、belongs_to和has_and_belongs_to_many

belongs_to 
这个类方法表示从一个ActiveRecord对象到另外单个具有一个外键属性的被关联对象的关联方法。
其选项有
:class_name 指定关联的类名，在关联名称不符合命名惯例的时候使用
:conditions 设置关联的约束条件
:foreign_key 指定用来查找关联对象的外键的列。一般情况下Rails会使用你所设的关联名称后面加_id的方法自动推算出外键的名称。
:counter_cache 这个选项让Rails自动更新被关联对象的从属对象数量。
:include 指定加载关联对象时同时要加载的关联对象，Rails会动态地在SELETE语句中加入必要的LEFT OUTER JOINS。

has_many
此关联允许你在一个数据模型中定义关联让他具有很多其他的附属的数据模型。选项有
:after_add 当一个记录通过<<方法被加入到集合中后会触发这个回调，但不会被集合的create方法触发。可以接受一个或多个方法名的符号或者Proc对象
:atfer_remove 当使用delete方法将一个记录从集合中移除时触发这个回调
:as指定被关联对象的多态belongs_to
:before_add 当一个记录通过<<方法被加入到集合之前触发这个回调，concat和push是<<的别名
:before_remove 当使用delete方法讲一个记录从集合中移除前触发回调
:class_name 当关联的类名不同于Rails自动推算出时，手动指定类名
:conditions 指定从数据库中取出对象的sql查询语句中加入额外的条件
:counter_sql  重载ActiveRecord自动生成的、用于统计关联中所包含的记录数量的sql。
:delete_sql 重载ActiveRecord自动生成的、用于取消关联的sql
:dependent=>:delete_all | :destroy_all | :nullify 其中delete_all使用单个sql语句删除被关联的对象，此方法不会触发被删除对象的任何destroy回调方法。destroy_all会逐个地调用被关联对象的destroy方法，将被关联的对象及父对象一起删除。nullity是默认选项，仅仅清除指向父对象的外键。
:finder_sql 指定一个完成的sql语句来读取关联，当关联非常复杂且需要依赖多个数据库表来获取数据时，可以利用这个选项
:foreign_key 重载ActiveRecord根据约定自动计算出的用于加载关联的sql语句中的外键名
:group 提供一个属性，计算结果自动根据这个属性进行分组，使用GROUP BY 
:include 同belongs_to
:insert_sql 重载ActiveRecord自动生成的、用于创建关联的sql语句。
:limit 在自动生成的、用于加载关联的sql中加入一个limit
:offset 设置结果集的偏移量
:order 类似sql的ORDER BY
:select 指定查询的字段
:table_name  关联的表名
:uniq=>true 从关联的集合中剔除重复的对象

has_one
这个关联相对比较简单
:class_name 关联的类名
:conditions 关联的条件  v cg 
:dependent 级联的操作
:foreign_key 关联的外键
:include 同上
:order 排序
=end

#### 校验 ####
=begin
Rails的ActiveRecord提供了许多校验的辅助方法简化操作
validates_acceptance_of 确认表单的checkbox是否被标记
validates_associated 确认关联对象，每个关联对象的nil?法被调用
validates_confirmation_of 确认字段和指定字段的值是否有同样的内容
validates_each 确认块内的每个属性
validates_exclusion_of 确认指定的属性值不会出现在一个特定的可枚举对象中
validates_format_of 确认指定的属性值是否匹配由正则表达式提供的正确格式
validates_inclusion_of 确认指定的属性值是否是一个特定的可枚举对象中的一个有效值
validates_length_of 确定指定的属性值是否是匹配约束的长度 validates_length_of为其别名
validates_numericality_of 确认一个属性值是否是数字
validates_presence_of 确认指定属性值是否为空
validates_uniqueness_of 确定指定的属性在系统中是否唯一

默认信息的定义
:inclusion=>"is not included in the list"
:exclusion=>"is reserved"
:invalid=>"is invalid"
:confirmation=>"doesn't match confirmation"
:accepted=>"must be accepted"
:empty=>"can't be empty"
:blank=>"can't be blank"
:too_long=>"is too long(maxinum is %d characters)"
:too_short=>"is too short(mininum is %d characters)"
:wrong_length=>"is the wrong length(should be %d charscters)"
:taken=>"has already been taken"
:not_a_number=>"is not a number"
可以使用:message选项来重写默认的错误信息。
=end

rescue
end
