#!/usr/bin/env ruby

require 'yaml'

# Directory containing the posts
posts_dir = '_posts'

# Get all markdown files
Dir.glob("#{posts_dir}/*.markdown").each do |file|
  puts "Processing #{file}..."
  
  # Read the file content
  content = File.read(file)
  
  # Split front matter and content
  if content.match(/\A(---\s*\n.*?\n?)^(---\s*$\n?)/m)
    front_matter_text = $1 + $2
    post_content = content[front_matter_text.length..-1]
    
    # Parse front matter
    front_matter = YAML.load($1)
    
    # Extract title and convert to URL slug
    title = front_matter['title']
    if title
      # Convert title to URL slug (same as Jekyll does)
      slug = title.downcase
                  .gsub(/[^a-z0-9\s-]/, '') # Remove special characters
                  .gsub(/\s+/, '-')          # Replace spaces with hyphens
                  .gsub(/-+/, '-')           # Replace multiple hyphens with single
                  .gsub(/^-|-$/, '')         # Remove leading/trailing hyphens
      
      # Add redirect_from if it doesn't exist
      unless front_matter['redirect_from']
        front_matter['redirect_from'] = "https://blog.vikki.in/#{slug}/"
        
        # Convert back to YAML and write file
        new_front_matter = YAML.dump(front_matter)
        new_content = "#{new_front_matter}---\n#{post_content}"
        
        File.write(file, new_content)
        puts "  Added redirect for: https://blog.vikki.in/#{slug}/"
      else
        puts "  Redirect already exists, skipping"
      end
    else
      puts "  No title found, skipping"
    end
  else
    puts "  No front matter found, skipping"
  end
end

puts "Done!"
