#!/usr/bin/ruby
# excoding: utf-8
#
# weather_hitokuchi_test.rb - ひとくち予報のRSSをパースするテスト
#
# How to use:
#
#   1. Webブラウザで http://www.weathermap.co.jp/hitokuchi_rss/#howto を開く
#   2. 都道府県と地域を選択すると、予報を配信しているURLが表示される
#   3. そのURLを引数にweather_hitokuchi_test.rbを実行
#
#     $ ruby weather_hitokuchi_test.rb http://feedproxy.google.com/hitokuchi_4610
#
require 'open-uri'
require 'nokogiri'
require 'pp'

def imgtag2weather(html)
  # <img src="http://www.weathermap.co.jp/rss/hitokuchi/images/ame.png"> -> ame
  html.scan(/images\/(.+).png/)[0][0]
end

# 3時間おきの天気予報
# 1番目のcontent:encodedの中のHTMLに表があるので、スクレイピングして取得
def weather_3h(doc)
  html = doc.search("//content:encoded")[0].children[0].content
  doc_sub = Nokogiri::HTML.parse(html)
  
  table = doc_sub.search("//table").search(".//table")[3]
  tds = table.search(".//td")
  
  ws = []
  (0..7).each do |i|
    w = {}
    w['t'] = tds[i].inner_html
    w['weather'] = imgtag2weather(tds[i + 8].inner_html)
    w['temperature'] = tds[i + 16].inner_html
    
    ws << w
  end
  
  ws
end

# 週間天気予報
def weather_week(doc)
  wm_forecast = doc.search("//wm:forecast[@term='week']")
  
  # <wm:forecast>タグの中にある<wm:content>タグの内容を表示
  wm_content = wm_forecast.search(".//wm:content")
  
  ws = []
  wm_content.each do |e|
    w = {}
    w['date'] = e.attr("date")
    
    # <wm:content>内の<wm:weather>タグを取得
    w['weather'] = e.search(".//wm:weather").inner_html
    
    ws << w
  end
  
  ws
end

def main
  doc = Nokogiri::XML.parse(open(ARGV[0]).read)
  
  puts "==== 3時間おきの天気 ===="
  pp weather_3h(doc)
  
  puts "==== 週間天気予報 ===="
  pp weather_week(doc)
end

main

