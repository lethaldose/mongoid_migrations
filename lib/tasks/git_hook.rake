namespace :git do
  desc 'symlink git pre commit hook'
  task :pre_commit_hook do
    root_path = File.expand_path(File.join(File.dirname(__FILE__) ,"../../"))
    target_fname = "#{root_path}/.git/hooks/pre-commit"
    File.delete(target_fname) if File.exists?(target_fname)
    puts "linking precommit hook to #{target_fname}"
    system `ln -s #{root_path}/lib/tasks/pre-commit #{target_fname}`
  end
end
