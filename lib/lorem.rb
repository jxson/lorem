class UnsupportedType < StandardError; end

class Lorem
  attr_reader :output
  attr_accessor :type, :count
  
  TYPES = [ :paragraphs, :sentences, :words ]
  
  LOREM = "Sed ut perspiciatis, unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam eaque ipsa, quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt, explicabo. Nemo enim ipsam voluptatem, quia voluptas sit, aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos, qui ratione voluptatem sequi nesciunt, neque porro quisquam est, qui dolorem ipsum, quia dolor sit, amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt, ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit, qui in ea voluptate velit esse, quam nihil molestiae consequatur, vel illum, qui dolorem eum fugiat, quo voluptas nulla pariatur? At vero eos et accusamus et iusto odio dignissimos ducimus, qui blanditiis praesentium voluptatum deleniti atque corrupti, quos dolores et quas molestias excepturi sint, obcaecati cupiditate non provident, similique sunt in culpa, qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio, cumque nihil impedit, quo minus id, quod maxime placeat, facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet, ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat."
  
  def initialize (type, count)
    @type = lorem_type_for(type)
    @count = count.to_i
    raise UnsupportedType unless TYPES.include?(type)
    @output = generate_lorem
  end 
  
  class << self
    def create (type, count)
      instance = Lorem.new(type, count)
      instance.output
    end
    
    def total_words
      LOREM.split(' ').size
    end
  end # end self
  
  private
    def lorem_type_for (symbol)
      symbol.to_sym
    end
    
    def generate_lorem
      send("output_#{@type}")
    end
    
    def random_words
      LOREM.split(' ').sort_by { rand }
    end
    
    def output_words
      if @count <= 1
        grab_words(@count).gsub(/\W/, '')
      else
        grab_words(@count)
      end
    end
    
    def output_sentences
      sentences = ''
      @count.times { sentences << make_sentence << ' ' }      
      sentences.strip
    end
    
    def output_paragraphs
      paragraphs = ''
      
      @count.times do
        sentence_count = rand(4) + 3
        sentence_count.times { paragraphs <<  make_sentence << ' ' }
        paragraphs << "\n\n"
      end
      paragraphs.strip
    end
    
    def grab_words (word_count)
      if word_count <= self.class.total_words
        random_words[0, word_count].join(' ')
      else
        repeat = (word_count / self.class.total_words.to_f).ceil
        (random_words * repeat)[0, word_count].join(' ')
      end
    end
    
    def make_sentence
      word_count = rand(9) + 8
      end_chars = ['.', '.', '.', '.', '!', '?', '...', ',']
      punct = end_chars.sort_by { rand }.last
      sentence = grab_words(word_count).capitalize
      last_char = sentence[sentence.length - 1, 1]
      if end_chars.include?(last_char)
        sentence.chop << punct
      else
        sentence << punct
      end
    end
  # end private
end

# Shortcut for Lorem.create
# 
# Example:
#   Lorem(:words, 10)
def Lorem (type, count)
  Lorem.create(type, count)
end
