class Cranky::Factory
  def book
    define title: 'Example Teacher Set', bnumber: DateTime.now.strftime('%Q')
  end
end
