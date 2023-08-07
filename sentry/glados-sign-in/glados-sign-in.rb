#coding:utf-8
require 'watir'

browser = Watir::Browser.new(:chrome)
browser.goto('https://glados.rocks/console/checkin')
unless File.exist? '.cookies'
  sleep 120
  browser.cookies.save '.cookies'
else
  browser.cookies.load '.cookies'
  browser.goto('https://glados.rocks/console/checkin')
  sleep 10
end

button = browser.button(class: 'ui positive button')
button.click
sleep 5
browser.close
