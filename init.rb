require 'lorem'

# Shortcut for Lorem.create
# 
# Example:
#   Lorem(:words, 10)
def Lorem(type, count)
  Lorem.create(type, count)
end