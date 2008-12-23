require 'test/unit'
require 'rubygems'
require 'fastercsv'
require File.dirname(__FILE__) + '/../lib/to_csv'
require File.dirname(__FILE__) + '/user_model'

class ToCsvTest < Test::Unit::TestCase

  def setup
    @users = []
    @users << User.new(:id => 1, :name => 'Ary', :age => 24)
    @users << User.new(:id => 2, :name => 'Nati', :age => 21)
  end

  def test_with_empty_array
    assert_equal( "", [].to_csv )
  end

  def test_with_no_options
    assert_equal( "id,name,age\n1,Ary,24\n2,Nati,21\n", @users.to_csv )
  end
  
  def test_with_no_headers
    assert_equal( "1,Ary,24\n2,Nati,21\n", @users.to_csv(:headers => false) )
  end
  
  def test_with_only
    assert_equal( "name\nAry\nNati\n", @users.to_csv(:only => :name) )
  end
  
  def test_with_empty_only
    assert_equal( "", @users.to_csv(:only => "") )
  end
  
  def test_with_only_and_wrong_column_names
    assert_equal( "name\nAry\nNati\n", @users.to_csv(:only => [:name, :yoyo]) )
  end
  
  def test_with_except
    assert_equal( "age\n24\n21\n", @users.to_csv(:except => [:id, :name]) )
  end
  
  def test_with_except_and_only_should_listen_to_only
    assert_equal( "name\nAry\nNati\n", @users.to_csv(:except => [:id, :name], :only => :name) )
  end
  
  def test_with_except
    assert_equal( "id,name,age,is_old?\n1,Ary,24,false\n2,Nati,21,false\n", @users.to_csv(:methods => [:is_old?]) )
  end
  
end
