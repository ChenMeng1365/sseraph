
# Problem

误删二进制文件时，如恢复策略不奏效，可以在压缩blob释放空间之前，从目录中找回，通过.properties文件描述恢复文件名、仓库及标签，对.bytes文件重命名恢复原始二进制文件。

nexus的物理目录一般名叫nexus-data，其blob存储路径可以通过管理页面查询("Repository" -> "Blob Stores"，默认blob是"default")，比如"nexus-data/blobs/default/content"。

blob文件是诸如下列结构的存储方式：

```shell
vol-07
└── chap-39
    ├── a0212900-d25c-47bc-b5e1-3e0251ddb36f.bytes
    └── a0212900-d25c-47bc-b5e1-3e0251ddb36f.properties
```

bytes文件是文件的二进制块

properties文件是文件的描述信息

# Resovle

使用如下脚本还原文件命名和设置存放目录

```ruby
require 'fileutils'

Dir["*/*/*.properties"].each do|path|
  abstract = File.read(path)
  tags = abstract.match(/@BlobStore\.blob-name=.*/).to_s.split("=")[1].split("/")
  repo = abstract.match(/@Bucket\.repo-name=.*/).to_s.split("=")[1]
  route = ([repo] + tags).map{|r|eval("\"#{r}\"")}
  route[0..-2].each_with_index do|head,index|
    Dir.mkdir(route[0..index].join("/")) unless File.exist?(route[0..index].join("/"))
  end
  FileUtils.mv path.gsub(".properties",".bytes"), route.join("/")
end
```

恢复完成后，即可按日程启动压缩blob空间的任务("Tasks" -> "Admin - Compact blob store")。
