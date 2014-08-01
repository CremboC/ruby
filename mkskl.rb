require 'fileutils'

# arguments not there? exit.
if ARGV[0].nil? || ARGV[1].nil?
  puts "Usage: mkskl.rb <project_name> <pat>"
  puts "Example: mkskl.rb blog /usr/share/ruby"
  exit 0
end

# duplicate so they are mutable
$project_name = ARGV[0].dup
$path = ARGV[1].dup

# FIXME: pls, shouldn't be like this
if $path[0, 1] == '~'
  puts "Musn't use ~ in project path"
  exit 0
end

# removes trailing /
if $path[-1, 1] == '/'
  $path.chomp '/'
end

# makes sure project_name has no spaces
if $project_name.include? " "
  puts "Project name contains spaces. This may result in unexpected behaviour."
  puts "It is recommended to not use spaces. Are you sure this is what you want?"
  puts "[C] to continue with spaces"
  puts "[R] to remove spaces from project_name"
  puts "[U] to replace spaces with underscores i.e. _"
  print "[X] to exit ... "
  
  inp = $stdin.gets.chomp
  
  case inp
    when "C"
      puts "Continuing execution..."
    when "R"
      puts "Deleting spaces"
      $project_name.delete ' '
    when "U"
      puts "Replacing spaces with underscores"
      $project_name.gsub! ' ', '_'
    when "X"
      puts "Exiting..."
      exit 0
    else 
      puts "Exiting..."
      exit 0
  end
end

# makes sure user didn't input project name by mistake
if $path.include? $project_name
  puts "Project name detected in path. This generator adds the project name to"
  puts "the end of the path automatically, are you sure this is what you want?"
  puts "Type one of the follow and press enter: "
  puts "[C] to continue without modifying the path" 
  puts "[R] to remove the project name from the path"
  print "[X] to exit ... "

  inp = $stdin.gets.chomp

  case inp
    when "C"
      puts "Continuing execution..."
    when "R"
      $path.slice! $project_name
    when "X"
      puts "Exiting..."
      exit 0
    else # in any other case exit
      puts "Exiting..."
      exit 0
   end
end

# concat path with project name
$project_path = "#{$path}/#{$project_name}"

print "Creating project file path...."

# create main folder with path provided and project name
created = FileUtils::mkdir_p $project_path

if created
  puts "Done"
else
  puts "Error creating folder, exiting..."
  exit 0
end

default_folders = ["ext", "tests", "bin", "doc", "lib", "tests", "data"]

# create all default folders
default_folders.each do |folder| 
  FileUtils::mkdir_p "#{$project_path}/#{folder}" 
end

# create project folder in lib
FileUtils::mkdir_p "#{$project_path}/lib/#{$project_name}"

##
## GEMSPEC FILE TEMPLATE
##
gemspec_templ = <<TEMPL
# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = $project_name
  spec.version       = '1.0'
  spec.authors       = ["Your Name Here"]
  spec.email         = ["youremail@yourdomain.com"]
  spec.summary       = %q{Short summary of your project}
  spec.description   = %q{Longer description of your project.}
  spec.homepage      = "http://domainforproject.com/"
  spec.license       = "MIT"

  spec.files         = ["lib/#{$project_name}.rb"]
  spec.executables   = ["bin/#{$project_name}"]
  spec.test_files    = ["tests/#{$project_name}_tests.rb"]
  spec.require_paths = ["lib"]
end
TEMPL

# create gemspec file
print "Creating gemspec file..."

File.open("#{$project_path}/#{$project_name}.gemspec", "w+") {
  |f|
  f.write(gemspec_templ)
  puts "Done"
}

##
## RAKEFILE TEMPLATE
##
rakefile_templ = <<TEMPL
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "tests"
  t.test_files = FileList['tests/test*.rb']
  t.verbose = true
end
TEMPL

# create Rakefile
print "Creating Rakefile..."

File.open("#{$project_path}/Rakefile", "w+") {
  |f|
  f.write(rakefile_templ)
  puts "Done"
}

# create file in bin
print "Creating stub in bin/..."
File.open("#{$project_path}/bin/#{$project_name}", "w+") {
  |f|
  f.write("")
  puts "Done"
}

# create rb in lib
print "Creating <project_name.rb> in lib/..."

File.open("#{$project_path}/lib/#{$project_name}.rb", "w+") {
  |f|
  f.write("puts 'Hello World!'")
}

puts "Done"
class String
  def camel_case
    return self if self !~ /_/ && self =~ /[A-Z]+.*/
    split('_').map{|e| e.capitalize}.join
  end
end

camelized_project_name = $project_name.camel_case

##
## TEST CASE TEMPLATE
##
test_templ = <<TMPL
require_relative "../lib/#{$project_name}.rb"
require "test/unit"

class Test#{camelized_project_name} < Test::Unit::TestCase

  def test_sample
      assert_equal(4, 2 + 2)
  end
        
end
TMPL

# creating test case sample..
print "Creating sample unit test..."

File.open("#{$project_path}/tests/test_#{$project_name}.rb", "w+") {
  |f|
  f.write(test_templ)
  puts "Done"
}
