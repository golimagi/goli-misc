# Goli路由设计&Api规范 草案

施工中：当前文档尚未完成。

##### 数据标准

请求方式统一为`POST`，`content-type`为json，返回内容为json。

为了方便书写和阅读，下文中的Json统一使用`JavaScript`中`json object`的写法。

##### 返回内容统一格式

`{error: Error, result: Object}`

`Error`统一格式为：`{code: Number, text: String}`，请求成功执行时为`null`。

当`error`为`null`时，不论`result`皆应视为请求成功。

##### Error code

统一采用与HTTP响应头**无关**的三个数字代码。

`Error`中的`text`供Debug参考，前端不应直接将其用作显示文本。

1. 1XX：该错误发生与用户层，如密码错误、权限不足等
2. 2XX：该错误通常由请求数据异常导致，可能需要前端开发人员重视。
3. 3XX：该错误发生于后端程序，如数据库连接、文件丢失等

### 获取数据类

#### /user/account
##### 获取用户的账号数据

和`/user/userinfo`类似，但此API还能获取到用户的邮箱、IP地址信息。非管理员仅能查询自己。

一次仅可查询一个用户

请求：`{user_id: Number}`

响应：
```javascript
{error: Error, result: {
  id: Number,
  name: String,
  usergroup: Number,
  registed: Number,
  last_login: Number,
  avatar: String
}}
```

#### /user/login
##### 请求login会话

请求：`{}`

响应：`{error: null, result:{salt: String}}`

salt为下一步密码验证所需

#### /user/auth
##### 验证用户密码

请求：
```javascript
{
  user_id: Number,
  user_name: String,
  user_mail: String,
  password: String
}
```
`user_id`，`user_name`，`user_mail`为可选项，但至少选择一项。

`password`：用户密码Hash后加Salt后再Hash的结果

响应：`{error: null, result: {login_succeed: true}}`(登陆成功) 

登陆失败的响应示例：
```javascript
{
  error: {code: 101, text: "invalid user or password"},
  result: {login_succeed: false}
}
```

#### /user/userinfo
##### 获取用户信息

此API获取用于用户信息，通常是用于获取其他用户的信息。如头像、名称、用户组等。

一次可以查询多个用户。

前端应缓存查询结果来减少查询次数

请求：`{user_ids: [Number]}`

响应：
```javascript
{error: null, result: [{
  id: Number,
  name: String,
  usergroup: Number,
  avatar: String
}]}
```
`result`为一个列表，包含查询的用户数据结果。

#### /video/info
##### 获取视频信息

请求：`{video_id: Number}`

响应：
```javascript
{error: null, result: {
  video_id: Number,
  user_id: Number,
  title: String,
  description: String,
  category: Number,
  tags: [Number],
  status: Number,
  play_times: Number,
  urls: [{resolution: String, link: String}]
}}
```

#### /video/comment
##### 获取视频评论

请求：`{video_id: Number, offset: Number, limit: Number, desc: Bool}`

`desc`为排序，默认为正序列(`false`)

`offset`为获取偏移

`limit`为需要获取评论的数量

响应 返回评论列表：
```javascript
{error: null, result: [{
  id: Number,
  user_id: Number,
  content: String,
  reply_to: Number
}]}
```

#### /video/danmaku
##### 获取弹幕

一次会返回该视频所有弹幕

请求：`{video_id: Number}`

响应：
```javascript
{error: null, result: [
  id: Number,
  user_id: Number,
  text: String,
  position: Number,
  offset: Number
]}
```

`text`: 弹幕文本（包含样式表）

`position`: 弹幕位置（上/中/下/滚）

`offset`: 弹幕出现时间

### 变更数据类

#### /user/edit
##### 编辑用户信息

请求：
```javascript
{
  user_id: Number,
  option: String,
  value: String,
  password: String,
  password_salt: String
}
```

`option`: 修改项，可选 `name` `avatar` `usergroup` `password`。

`value`: 修改后的值

`password`: 用户当前密码 Hash。计算方式同用户登陆，仅`option`为`password`时需要

修改`password`需要`password`与用户当前`password`匹配。

`password_salt`: 计算`password` Hash 时采用的 salt ，由前端生成即可，不需要请求`/user/login`获取

成功响应：`{error: null, result: null}`

失败响应（示例）：`{error: {code: 103, text: "invalid password"}, result: null}`

#### /user/recover
##### 用户使用辅助手段重置密码

请求：`{user_id: Number, password: String, token: String}`

`password`为密码的Hash

成功响应：`{error: null, result: null}`

失败响应（示例）：`{error: {code: 104, text: "invalid token"}, result: null}`

#### /video/plus1s
##### 将视频播放次数 +1

当用户视频播放时间超过视频总时长 1/3 时，前端应请求此 api 为视频播放次数 +1

请求：`{video_id: Number}`

响应：`{error: null, result: null}`

#### /video/comment/new
##### 添加评论

请求：`{video_id: Number, content: String, reply_to: Number}`

`reply_to`: 回复其它评论的`comment_id`。后端应确保回复在同一视频下。

响应：`{error: null, result: {id: Number}}`

返回该评论的`id`。

#### /video/comment/edit
##### 修改评论

请求：`{comment_id: Number, content: String}`

若`content`为空，则删除该评论。

响应：`{error: null, result: null}`

#### /video/danmaku/new
##### 添加弹幕

请求：`{video_id: Number, text: String, position: Number, offset: Number}`

参考 _获取弹幕_

响应：`{error: null, result: {id: Number}}`

#### /video/danmaku/del
##### 删除弹幕

请求：`{danmaku_id: Number}`

响应：`{error: null, result: null}`