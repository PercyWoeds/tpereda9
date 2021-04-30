module Utils

  def is_like(query)
    "%" + query + "%"
  end

  def case_insensitive_search(query)
    "lower(#{query}) like :#{query}"
  end

end
