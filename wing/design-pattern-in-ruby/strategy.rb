class Array  
  def sort options   
    if options[:strategy].to_sym == :bubble_sort  
      bubble_sort()
    elsif options[:strategy].to_sym == :quick_sort  
      quick_sort()
    end  
  end  
end  

def bubble_sort
  puts :bubble_sort
end

def quick_sort
  puts :quick_sort
end


#arr = Array.new
# arr.sort :strategy => 'bubble_sort'
# arr.sort :strategy => 'quick_sort'

# 你懂的
__send__ :bubble_sort
__send__ :quick_sort