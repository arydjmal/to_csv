class Array
  
  def to_csv(options = {})
    if options[:only]
      columns = options[:only].to_a
    else
      columns = self.first.class.columns.collect {|c| c.name.to_sym} - options[:except].to_a
      columns -= [:created_at, :updated_at] unless options[:timestamps] == true
      columns -= [:id] unless options[:id] == true
    end
    
    # Expand methods, [{:user => [:name, :id]}] => [{:user => :name}, {:user => :id}]
    if methods = options[:methods]
      methods = methods.collect do |method|
        if method.is_a?(Symbol)
          method
        else
          if method[method.keys.first].is_a?(Array)
            method[method.keys.first].collect {|association_method| [{method.keys.first => association_method}]}
          else
            method
          end
        end
      end
      columns << methods
    end
    
    columns = columns.flatten
    
    output = FasterCSV.generate do |csv|
      
      unless options[:header] == false
        csv << columns.collect do |column|
          if column.is_a?(Symbol)
            column
          else
            "#{column.keys.first}_#{column[column.keys.first]}"
          end
        end
      end 
      
      self.each do |item|
        csv << columns.collect do |column|
          if column.kind_of?(Hash)
            item.send(column.keys.first).send(column[column.keys.first])
          else
            item.send(column)
          end
        end
      end
    end
    
    output
  end
  
end
