class Array
  # This to_csv is borrowed and adapted from https://github.com/arydjmal/to_csv/blob/master/lib/to_csv.rb
  # works like to_xml and whatever but also has preferred_order and column_names options
  def to_csv(options = {})
  
    return '' if self.empty?

    klass      = self.first.class
    attributes = self.first.attributes.keys.sort.map(&:to_sym)

    if options[:preferred_order]
      columns = Array(options[:preferred_order])
    else
      if options[:only]
        columns = Array(options[:only]) & attributes
      else
        columns = attributes - Array(options[:except])
      end
      columns += Array(options[:methods])
    end

    return '' if columns.empty?
    
    if options[:column_names]
      column_names = Array(options[:column_names])
    else
      column_names = columns.map { |column| klass.human_attribute_name(column) } unless options[:headers] == false
    end

    output = CSV.generate do |csv|
      csv << column_names
      self.each do |item|
        csv << columns.collect { |column| item.send(column) }
      end
    end

    output

  end

end