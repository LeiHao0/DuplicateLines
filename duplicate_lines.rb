require 'find'

class DuplicateLines
  @@allLines = { "test" => 0 }
  @@path = "#{ARGV[0]}"

  def initialize()
    path = "."  if @@path == ""
    fileWalk(path)
    generateResult
    printResult
  end

  def generateResult
    @@allLines = @@allLines.delete_if { |k, v| v < 3 } # 去除 重复次数 < 3
    @@allLines = @@allLines.delete_if { |k, v| k.to_s.length < 6 } # 去除 语句字符数 < 6
    @@allLines = @@allLines.sort_by { |k, v| v }
  end

  def fileWalk(path)
    Find.find(path) do |f|
      case f
        # 只打开 *.m 文件
        when /\.m/
          readFile(f)
      end
    end
  end

  @@keywords = ["break", "}", "{", "//", "nil", nil, "@end", "else", "YES", "NO"]

  def readFile(path)
    open(path).each { |line|
      # 去除 注释行|赋值语句之前的变量|空格
      l = line.gsub(/\/\/.*|^.* = |[\s]|;/, '').strip

      if l != "" && !@@keywords.include?(l)
        n = @@allLines[l].to_i + 1
        @@allLines[l] = n
      end
    }
  end

  def printResult
    @@allLines.each { |x| p x}
  end

end

DuplicateLines.new