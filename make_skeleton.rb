
require 'fileutils'

project_name, path  = ARGV

# FIXME: pls, shouldn't be like this
if path[0, 1] == '~'
  puts "Musn't use ~ in project path"
  exit(0)
end

# removes trailing /
if path[-1, 1] == '/'
 path.chomp('/')
end

# concat path with project name
project_path = "#{path}/#{project_name}"

# create main folder with path provided and project name
created = FileUtils::mkdir_p project_path

if created
  puts "Created project file path"
end





