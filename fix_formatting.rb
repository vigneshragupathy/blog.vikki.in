#!/usr/bin/env ruby

require 'yaml'

# Get all markdown files in _posts directory
posts_dir = '_posts'
posts = Dir.glob("#{posts_dir}/*.{md,markdown}").sort

posts.each do |post_file|
  puts "Processing: #{post_file}"
  
  # Read the file content
  content = File.read(post_file)
  
  # Split front matter and content
  if content.start_with?('---')
    parts = content.split('---')
    if parts.length >= 3
      # Remove empty first part and get YAML and content
      front_matter_yaml = parts[1]
      post_content = parts[2..-1].join('---')
      
      begin
        # Parse YAML front matter
        front_matter = YAML.load(front_matter_yaml)
        
        # Skip if no title
        next unless front_matter['title']
        
        # Fix the specific Tamil title post
        if front_matter['title'] == 'எங்கள் ஊர்த் திருவிழா'
          front_matter['redirect_to'] = 'https://vigneshragupathy.com/thiruvizha-madukkur-2018/'
        end
        
        # Write back to file with proper formatting
        File.open(post_file, 'w') do |file|
          file.write("---\n")
          file.write(YAML.dump(front_matter))
          file.write("---")
          file.write(post_content)
        end
        
        puts "  ✓ Fixed formatting for #{post_file}"
        
      rescue => e
        puts "  ✗ Error processing #{post_file}: #{e.message}"
      end
    end
  end
end

puts "\nFinished fixing all posts!"
