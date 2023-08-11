
module ProcMon
  module_function

  def info
    list  = {}
    list1 = `wmic process get processid,executablepath`.force_encoding("GBk").encode("UTF-8").to_s.split("\n").select{|i|i!=""}.map{|i|i.split(" ")}
    list2 = `wmic process get processid,name`.force_encoding("GBk").encode("UTF-8").to_s.split("\n").select{|i|i!=""}.map{|i|i.split(" ")}
    netst = `netstat -ano`.force_encoding("GBk").encode("UTF-8").to_s.split("\n").select{|i|i!=""}.map{|i|t=i.split(" ");t.first=='UDP' ? t.insert(-2,"") : :ok;t}

    list1.each do|item|
      path,pid = item[0..-2].join(" "),item.last
      list[pid] ||= {'pid'=>pid}
      list[pid]['加载路径'] = path
    end

    list2.each do|item|
      name,pid = item[0..-2].join(" "),item.last
      list[pid] ||= {'pid'=>pid}
      list[pid]['程序名'] = name
    end

    netst[2..-1].each do|nets|
      pid = nets.last
      list[pid] ||= {'pid'=>pid}
      ["协议", "本地地址", "外部地址", "状态"].each_with_index do|field,index|
        list[pid][field] = nets[index]
      end
    end

    return list.values[1..-1]
  end

  def query option={}
    procs = option[:procs] ? option[:procs] : ProcMon.info
    filts = procs
    filts = filts.select{|proc|proc["pid"]==option[:pid].to_s} if option[:pid]
    filts = filts.select{|proc|proc["程序名"].to_s.upcase.include?(option[:name].to_s.upcase)} if option[:name]
    filts = filts.select{|proc|proc["加载路径"].to_s.upcase.include?(option[:path].to_s.upcase)} if option[:path]
    filts = filts.select{|proc|proc["协议"].to_s.upcase.include?(option[:proto].to_s.upcase)} if option[:proto]    

    filts = filts.select{|proc|
      addr = option[:local_addr].to_s.include?(":")&&!option[:local_addr].to_s.include?("[") ? "[#{option[:local_addr]}]" : option[:local_addr].to_s
      proc["本地地址"].to_s.include?(addr+":")
    } if option[:local_addr]
    filts = filts.select{|proc|proc["本地地址"].to_s.include?(":"+option[:local_port].to_s)} if option[:local_port]
    filts = filts.select{|proc|
      addr = option[:remote_addr].to_s.include?(":")&&!option[:remote_addr].to_s.include?("[") ? "[#{option[:remote_addr]}]" : option[:remote_addr].to_s
      proc["外部地址"].to_s.include?(addr+":")
    } if option[:remote_addr]
    filts = filts.select{|proc|proc["外部地址"].to_s.include?(":"+option[:remote_port].to_s)} if option[:remote_port]

    filts = filts.select{|proc|proc["状态"].to_s.include?(option[:state].to_s.upcase)} if option[:state]

    return {
      'rand' => filts.clone.shuffle.first,
      'head' => filts.first,
      'last' => filts.last,
      ''     => filts
    }[option[:choose].to_s.downcase]
  end
end

__END__

loop do
  daemon = ProcMon.query(local_port: 80)
  if daemon.empty?
    system "D: && cd D:/workspace/web && rubyw server.rb" 
  else
    puts [:ok, daemon]
  end
  sleep 300
end

pp ProcMon.query(local_port: 80)
