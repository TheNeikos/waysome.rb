require 'json'
require './lib/waysome.rb'
tr = Waysome::Transaction.create("transaction_name") do |t|

  t.id        1337
  t.execute   true
  t.register  false


  t.push 1
  t.push 2
  t.push 5

  t.band ->{ -3 }, 3

  t.call ->{ 0 }, "log", "Example transaction ", 8, "Last value on stack is ", ->{ -1 }
end.to_hash.to_json

puts tr
