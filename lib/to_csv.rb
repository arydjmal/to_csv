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
