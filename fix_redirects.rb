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
    parts = content.split('---', 3)
    if parts.length >= 3
      front_matter_yaml = parts[1]
      post_content = parts[2]
      
      begin
        # Parse YAML front matter
        front_matter = YAML.load(front_matter_yaml)
        
        # Skip if no title
        next unless front_matter['title']
        
        # Generate the URL path from title (same as Jekyll permalink: :title/)
        title = front_matter['title']
        url_path = title.downcase
                       .gsub(/[^a-z0-9\s-]/, '') # Remove special characters except spaces and hyphens
                       .gsub(/\s+/, '-')         # Replace spaces with hyphens
                       .gsub(/-+/, '-')          # Replace multiple hyphens with single
                       .gsub(/^-|-$/, '')        # Remove leading/trailing hyphens
        
        # Add redirect_to to vigneshragupathy.com
        front_matter['redirect_to'] = "https://vigneshragupathy.com/#{url_path}/"
        
        # Remove redirect_from if it exists (since we're redirecting TO, not FROM)
        front_matter.delete('redirect_from')
        
        # Write back to file
        File.open(post_file, 'w') do |file|
          file.write("---\n")
          file.write(YAML.dump(front_matter))
          file.write("---")
          file.write(post_content)
        end
        
        puts "  ✓ Added redirect_to: https://vigneshragupathy.com/#{url_path}/"
        
      rescue => e
        puts "  ✗ Error processing #{post_file}: #{e.message}"
      end
    end
  end
end

puts "\nFinished processing all posts!"
