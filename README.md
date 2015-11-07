weather_hitokuchi_test.rb
====
ひとくち予報のRSSをパースするテスト

How to use
----

- 1. Webブラウザで http://www.weathermap.co.jp/hitokuchi_rss/#howto を開く
- 2. 都道府県と地域を選択すると、予報を配信しているURLが表示される
- 3. そのURLを引数にweather_hitokuchi_test.rbを実行

    $ ruby weather_hitokuchi_test.rb http://feedproxy.google.com/hitokuchi_4610

