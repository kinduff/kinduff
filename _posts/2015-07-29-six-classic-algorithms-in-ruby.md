---
title: Six classic algorithms in Ruby
date: 2015-07-29
description: This is a list of six algorithms written in Ruby. I did this as an exercise a long time ago when I was learning the language.
lang: en_US
---

## Linear search

This is a basic search algorithm. It iterates in a collection or in a data structure until it finds a value that matches.

```ruby
def findIndex(values, target)
  values.each_with_index do |value, i|
    return i if value == target
  end
end

findIndex([4, 8, 15, 16, 23, 42], 15)
# => 2
```

The function iterates over each value of an array and compares the index with the value in memory. If this matches, the index is returned.

## Linked list

Linear data structure where each object, called nodes, is linked to its predecessor and sometimes to its successor.

```ruby
class LinkedList
  def initialize
    @head = @tail = nil
  end

  def add(value)
    node = Node.new(value)

    @head = node if @head.nil?
    @tail.next = node unless @tail.nil?

    @tail = node
  end
end

class Node
  def initialize(value)
    @value = value
    @next = nil
  end

  def next
    @next
  end

  def next=(value)
    @next = value
  end
end

list = LinkedList.new()
list.add(1)
# => current: 1, head: true, tail: true, next: nil
list.add(2)
# => current: 2, head: false, tail: true, next: nil
list.add(3)
# => current: 3, head: false, tail: true, next: nil

# Final Result
# Current: 1, head: true, tail: false, next: 2
# Current: 2, head: false, tail: false, next: 3
# Current: 3, head: false, tail: true, next: nil
```

To manipulate the `LinkedList` class we will have to update the reference of the `head`, `tail` and `next` attributes. The following example corresponds to the update of values if one was removed.

```ruby
def removeAt(index)
  prev = nil
  node = @head
  i = 0
  loop do
    prev = node
    node = node.next
    i += 1
    break unless !node.nil? and i < index
  end
  if prev.nil?
    @head = node.next
  else
    prev.next = node.next
  end
end
```

## Hash table

The basic concept of a hash table is to insert a value in a bucket based on its hashed value.

```ruby
class HashTable
  def initialize(size)
    @size = size
    @buckets = Array.new(@size)
  end

  def add(value)
    index = hash(value)
    @buckets[index] = value
  end

  def hash(value)
    sum = 0
    0.upto(value.size-1) do |i|
      sum += value[i].ord - 97
    end
    return sum % @size
  end
end

hash = HashTable.new(3)
# => [nil, nil, nil]

hash.add('foo')
# => [nil, nil, "foo"]

hash.add('bar')
# => ["bar", nil, "foo"]

hash.add('candy')
# => ["bar", "candy", "foo"]
```

The hashing is prior to cause collisions, it's part of the nature of this type of algoritm (see [Birthday Problem](https://en.wikipedia.org/wiki/Birthday_problem)). A way to deal with this is by using a Linked List, for example:

```ruby
class LinkedList
  #...
end

class Node
  #...
end

class HashTable
  def initialize(size)
    @size = size
    @buckets = Array.new(@size)
    0.upto(@size) do |i|
      @buckets[i] = LinkedList.new
    end
  end

  def add(value)
    #...
  end

  def hash(value)
    #...
  end
end
```

#### Binary Search

It is based on the principle of divide and conquer in order to find a value in an ordered list.

```ruby
def findIndex(values, target)
  binarySearch(values, target, 0, values.size - 1)
end

def binarySearch(values, target, start, finish)
  return -1 if start > finish

  middle = ((start+finish)/2).floor
  value = values[middle]

  puts "From #{start} to #{finish}. Middle: #{middle}"

  return binarySearch(values, target, start, middle-1) if value > target
  return binarySearch(values, target, middle+1, finish) if value < target

  puts "Result: #{middle}"
  return middle
end

findIndex([2, 4, 6, 8, 10, 12, 14, 16, 18, 20], 6)

# =>
# From 0 to 9. Middle: 4
# From 0 to 3. Middle: 1
# From 2 to 3. Middle: 2
# Result: 2
```

#### Bubble Sort

It is the most basic way to order a collection. It iterates over each value and compares with the next and switch places if necessary. The iteration is repeated until all the values are not interchangeable.

```ruby
def sort(values)
  length = values.size - 2
  swapped = true

  while swapped
    swapped = false

    0.upto(length) do |i|
      if values[i] > values[i+1]
        values[i], values[i+1] = values[i+1], values[i]
        swapped = true
      end
    end
  end

  return values
end

sort([7, 4, 5, 2, 9, 1])

# output in each step
# =>
# 7, 4, 5, 2, 9, 1
# 4, 5, 2, 7, 1, 9
# 4, 2, 5, 1, 7, 9
# 2, 4, 1, 5, 7, 9
# 2, 1, 4, 5, 7, 9
# 1, 2, 4, 5, 7, 9
```

#### Insertion Sort

Unlike Bubble Sort, this algorithm inserts the iterated value in the correct place based on their ancestors making a comparison with each one.

```ruby
def sort(values)
  length = values.size - 1

  1.upto(length) do |i|
    temp = values[i]
    j = i - 1

    while j >= 0 and values[j] > temp
      values[j+1] = values[j]
      j -= 1
    end

    values[j+1] = temp
  end

  return values
end

puts sort([7, 4, 5, 2, 9, 1])

# output in each step
# =>
# 4, 7, 5, 2, 9, 1
# 4, 5, 7, 2, 9, 1
# 2, 4, 5, 7, 9, 1
# 2, 4, 5, 7, 9, 1
# 1, 2, 4, 5, 7, 9
```

## Final notes

I'm not very good at algorithms and probably these versions can be better, but it was very fun exercise. I found really good sources and explanations while I was researching each of these algorithms.

I really recommend checking out [The Sound of Sorting](http://panthema.net/2013/sound-of-sorting/), it's a small program that helps out to visualize and _hear_ various sorting algorithms.
