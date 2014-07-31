require 'fileutils'

$project_name = ARGV[0].dup
$path = ARGV[1].dup

# arguments not there? exit
if ($project_name.nil? || $path.nil?)
  puts "Usage: mkskl.rb <project_name> <path>"
  puts "Example: mkskl.rb blog /usr/share/ruby"
  exit 0
end

# FIXME: pls, shouldn't be like this
if $path[0, 1] == '~'
  puts "Musn't use ~ in project path"
  exit 0
end

# removes trailing /
if $path[-1, 1] == '/'
  $path.chomp '/'
end

# makes sure user didn't input project name by mistake
if $path.include? $project_name
  puts "Project name detected in path. This generator adds the project name to"
  puts "the end of the path automatically, are you sure this is what you want?"
  puts "Type [Y] to continue, [N] to remove the project name from the path"
  print "Or [X] to exit ... "

  inp = $stdin.gets.chomp

  case inp
    when "Y"
      puts "Continuing execution.."
    when "N"
      $path.slice! $project_name
    when "X"
      puts "Exiting.."
      exit 0
    else # in any other case exit
      puts "Exiting..."
      exit 0
   end
end

puts $path

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

default_folders = ["ext", "tests", "bin", "doc", "lib", "tests"]

# create all default folders
default_folders.each do |folder| 
  FileUtils::mkdir_p "#{$project_path}/#{folder}" 
end






