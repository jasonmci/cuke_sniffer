# encoding: utf-8
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rspec'
require 'cuke_sniffer'
require 'roxml'

include CukeSniffer::RuleConfig

def build_file(lines, file_name = @file_name)
  file = File.open(file_name, "w")
  lines.each { |line| file.puts(line) }
  file.close
end

def delete_temp_files
  file_list = [
      @file_name,
      "cuke_sniffer_results.html",
      "cuke_sniffer.xml"
  ]
  file_list.each do |file_name|
    File.delete(file_name) if !file_name.nil? and File.exists?(file_name)
  end

  reset_test_output
end

def reset_test_output
  $stdout.close if $stdout.class == File
  $stdout = STDOUT
  File.delete("test_output") if File.exists?("test_output")
  $stdout = File.new( 'test_output', 'w' )
end

def verify_rule(object, rule, count = 1)
  object.rules_hash[rule.phrase].should == count
  object.score.should >= rule.score
end

def verify_no_rule(object, rule)
  object.rules_hash[rule.phrase].should == nil
end

def remove_rules(rule_objects)
  rule_objects.each do |rule_object|
    rule_object.rules_hash = {}
    rule_object.score = 0
  end
end