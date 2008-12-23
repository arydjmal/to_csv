class Array
  
  def to_csv(options = {})
    return '' if self.empty?
    
    all_columns = self.first.class.columns.collect { |c| c.name.to_sym }
    
    if options[:only]
      columns = options[:only].to_a
    else
      columns = all_columns - options[:except].to_a
    end
    
    columns = columns & all_columns
    
    columns += options[:methods].to_a
    
    return '' if columns.empty?
    
    output = FasterCSV.generate do |csv|
      csv << columns unless options[:headers] == false
      self.each do |item|
        csv << columns.collect { |column| item.send(column) }
      end
    end
    
    output
  end
  
end
