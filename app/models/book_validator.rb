class BookValidator

  attr_accessor :matching_api_items

  def initialize(book)
    @book = book
  end
 
  def validate
    if !@book.catalog_choice.nil? && !@book.catalog_choice.empty? 
      nil

    elsif @book.details_url.nil?
      self.matching_api_items = @book.matching_api_items
      puts "should this pass validation? #{self.matching_api_items}"
      if self.matching_api_items.nil? || self.matching_api_items.size != 1
        # @book.errors[:base] << "#{self.matching_api_items.size} matching titles"
        @book.errors[:base] << self #"#{self.matching_api_items.size} matching titles"
      end
    end
  end

  def to_s
    "#{self.matching_api_items.nil? ? 'None' : self.matching_api_items.size} matching titles. Please choose one."
  end

  def empty?
    false
  end

end
