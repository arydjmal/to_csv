# Copyright (c) 2008 Ary Djmal
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

class Array
  
  def to_csv(options = {})
    
    if options[:only]
      columns = options[:only].to_a
    else
      columns = self.first.class.columns.collect {|c| c.name.to_sym} -
                  options[:except].to_a + options[:methods].to_a
      columns -= [:created_at, :updated_at] unless options[:timestamps] == true
      columns -= [:id] unless options[:id] == true
    end
    
    CSV::Writer.generate(output = "") do |csv|
      csv << columns.collect {|c| c} unless options[:header] == false
      self.each do |item|
        csv << columns.collect {|c| item.send(c)}
      end
    end
    
    output
    
  end
  
end
