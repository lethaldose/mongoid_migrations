desc 'Adds the magic encoding comment (Ruby 1.9) to all Ruby files'
task :magic_encoding do
  require 'magic_encoding'
  AddMagicComment.process []
end
