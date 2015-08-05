# copy all files
# rename necessary files
# cheer
require 'active_support/core_ext/string'
require 'fileutils'
require 'shellwords'

class Gemplater
  def initialize(path, name, class_name, whom, email, desc)
    @path = path
    @name = name
    @class_name = class_name
    @whom = whom
    @email = email
    @desc = desc
    @new_home = File.expand_path(File.join(path, name))
    @old_home = File.expand_path(".")
  end

  def perform_magic_show
    if File.exist?(path_for(:new, "Gemfile"))
      puts "Cannot generate into an existing project!!"
    else
      copy_template
      rename_files
      glob_files
      `git init #{path_for(:new, "").shellescape}`
    end
  end

  def path_for(where, parts)
    path = self.instance_variable_get(:"@#{where}_home")
    File.join(path, *parts)
  end

  def copy_template
    FileUtils.cp_r @old_home, @new_home
    decruft
  end

  def decruft
    FileUtils.rm_rf path_for(:new, ".git")
    FileUtils.rm_rf path_for(:new, "*.gem")
    FileUtils.rm path_for(:new, "generate.rb") 
    FileUtils.rm path_for(:new, "Gemfile.lock")
  end

  def rename_files
    [%w(lib gemplate.rb), %w(gemplate.gemspec),
     %w(lib gemplate), %w(spec lib gemplate_spec.rb)].each do |pattern|
      move(pattern)
    end
  end

  def glob_files
    files = Dir.glob(path_for(:new, "**/*"))
    files.each do |file_path|
      replace_strings(file_path) if File.file?(file_path)
    end
  end

  def replace_strings(file_path)
    slurped = IO.read(file_path)
    replacements = ["gemplate", @name,
                    "Gemplate", @class_name,
                    "1970-01-01", Time.now.strftime("%Y-%m-%d"),
                    "{{author}}", @whom,
                    "{{email}}", @email,
                    "{{description}}", @desc
    ]
    replacements.each_slice(2) do |slice|
      slurped.gsub!(*slice)
    end

    IO.write(file_path, slurped)
  end

  def move(pattern)
    old_thing = path_for(:new, pattern)
    replacement = pattern[0...-1]
    replacement <<  pattern.last.sub("gemplate", @name)
    new_thing = path_for(:new, replacement)
    FileUtils.mv old_thing, new_thing
  end

end

if path = ARGV[0]
  print "What shall we call this gem?: "
  gem_name = STDIN.gets.strip.downcase
  print "How shall we list the author's name?: "
  my_name = STDIN.gets.strip
  print "And the author's email address?: "
  my_email = STDIN.gets.strip
  print "Next, a brief gem description: "
  my_desc = STDIN.gets.strip
  class_name = gem_name.classify
  puts "I'm going to create #{class_name} at #{path}#{gem_name}"
  print "If #{class_name} isn't a good class name for you, enter your preference: "
  alt_name = STDIN.gets.strip
  unless alt_name.blank?
    class_name = alt_name
  end
  puts "Generating #{class_name} at #{path}#{gem_name}"
  Gemplater.new(path, gem_name, class_name, my_name, my_email, my_desc).perform_magic_show

else
  puts "Usage: ruby generate.rb <path>"
end
