
# bundle

1. 编写Gemfile,指定依赖
2. `bundle init`
3. 编写gemspec
4. `gem build XXX.gemspec`或`bundle exec pod install/update --verbose --no-repo-update`
5. `gem install ./XXX.gem`
