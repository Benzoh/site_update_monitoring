#! /usr/local/bin/ruby
# coding: utf-8

require 'kconv'
require 'open-uri'
require 'openssl'
require 'timeout'
require 'nokogiri'
require './send_line_notify.rb'

class CheckHtml
  # テスト用URL
  # URL = "http://www.yahoo.co.jp/"
  # URL = "https://search.yahoo.co.jp/realtime/search/HRT/?fr=rts_top_bzmod"
  
  # TODO: 監視したいサイト
  URL = "http://www.pet-home.jp/dogs/cg_1060/baby/girl/"

  # TODO: change your path
  DIR = "./temp"
  FILE_L = "#{DIR}/last.txt"
  FILE_C = "#{DIR}/current.txt"
  
  # TODO: admin mail address
  ADMIN = 'benzoh@hippohack.me'
  
  TIMEOUT = 15
  UA = "mk-mode Bot (Ruby/#{RUBY_VERSION}, Administrator: #{ADMIN}"
  CHARSET = nil

  # メイン処理
  def exec
    read_html_last
    get_html_current
    save_html_current

    puts @html_c
    puts @html_l

    # puts @html_c.eql?(@html_l)

    if (@html_c. == @html_l)
      p '差分なし'
      return
    else
      p '差分あり'
    end

    save_html_last
    # save_html_timestamp

    line = Line.new
    msg = 'test'
    # msg = 'サイトに更新がありました - http://www.pet-home.jp/dogs/cg_1060/baby/girl/'
    res = line.send(msg)
    puts res.code
    puts res.body

  rescue => e

    $stderr.puts "[#{e.class}] #{e.message}"
    e.backtrace.each{ |bt| $stderr.puts "\t#{bt}" }
    exit 1

  end

  private

  # 前回HTML
  def read_html_last
    @html_l = File.exists?(FILE_L) ? File.open(FILE_L, "r").read.chomp : ""
  rescue => e
    raise
  end
  
  # 今回HTML
  def get_html_current
    charset = nil
    html = URI.open(URL) do |f|
      charset = f.charset
      f.read
    end
    doc = Nokogiri::HTML.parse(html, nil, charset)

    # TODO: your html xpath
    doc.xpath('//li[@class="contribute_result"]').each do |node|
      @html_c = node.xpath('//h3[@class="title"]').first.text.strip
    end
    
  rescue => e
    raise
  end
  
  # def get_html_current
  #     timeout(TIMEOUT) do
  #         @html_c = open(
  #             URL,
  #             {'User-Agent' => UA, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE}
  #         ) do |f|
  #             f.read
  #         end.chomp.toutf8
  #     end
  # rescue => e
  #     raise
  # end

  # 今回のHTML保存
  def save_html_current
    File.open(FILE_C, 'w') { |f| f.puts @html_c }
  rescue => e
    raise
  end
  
  # 今回のHTMLを前回のHTMLとして保存
  def save_html_last
    File.open(FILE_L, 'w') { |f| f.puts @html_c }
  rescue => e
    raise
  end
  
  # 今回のHTMLをタイムスタンプ付きファイル名としても保存
  def save_html_timestamp
    file_name = "#{DIR}/#{Time.now.strftime("%y%m%d_%H%M%S")}.txt"
    File.open(file_name, 'w') { |f| f.puts @html_c }
  rescue => e
    raise
  end
end

# 実行
CheckHtml.new.exec if __FILE__ == $0
