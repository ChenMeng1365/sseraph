function elementIterator (collection)
  local index = 0
  local count = #collection
  return function ()
    index = index + 1
    if index <= count then
      return collection[index]
    end
  end
end

function iter (a, i)
  i = i + 1
  local v = a[i]
  if v then
    return i, v
  end
end

function ipairs (a)
  return iter, a, 0
end
