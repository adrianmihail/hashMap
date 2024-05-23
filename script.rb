class HashMap

  GROWTH_RATE = 0.75
  INITIAL_SIZE = 16

  def initialize(size = INITIAL_SIZE)
    @size = size
    @buckets = Array.new(size)
    @lenght = 0
  end

  def hash(key)
    hash_code = 0
    prime_number = 31
       
    key.to_s.each_char { |char| hash_code = prime_number * hash_code + char.ord }
       
    hash_code % @size
  end

  def current_load
    @lenght.to_f / @size
  end

  def rehash
    @size *= 2
    new_bucket = entries.flat_map {|pair| pair.map {|key, value| [key, value]}}
    @buckets = Array.new(@size)
    @lenght = 0
    new_bucket.each {|pair| set(pair[0], pair[1])}
  end
  

  def set(key, value)
    index = hash(key)
    entry = {key => value}

    if !@buckets[index]
      @buckets[index] = entry
    else
      @buckets[index][key] = value
      @buckets.pop
    end

    @lenght += 1

    rehash if current_load > GROWTH_RATE
  end

  def get(key)
    @buckets[hash(key)][key] if has?(key)
  end

  def has?(key)
    @buckets[hash(key)] ? @buckets[hash(key)].include?(key) : false
  end

  def remove(key)
    if has?(key)
      value = get(key)
      @buckets[hash(key)] = nil
      @lenght -= 1
      return value
    end
    nil
  end

  def clear
    @lenght = 0
    @buckets = Array.new(INITIAL_SIZE)
  end

  def keys
    entries.map(&:keys).flatten
  end

  def values
    entries.map(&:values).flatten
  end

  def entries
    @buckets.compact.flat_map {|hash| hash.map {|key, value| {key => value}}}
  end
end

hm = HashMap.new

p hm.set(110,"idg")
p hm.set(109,"idd")
p hm.set(232,"idg")
p hm.entries