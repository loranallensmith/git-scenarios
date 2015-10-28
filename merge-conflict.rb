#!/usr/bin/env ruby

# Generate a repository with a merge conflict on the horizon.
# When run, this will create a new repository within which the
# user will experience a merge conflict upon running `git merge feature`

require 'git'

if Dir.exists?('merge-conflict')
  puts "It looks like you have a directory called 'merge-conflict' in this directory.\nPlease delete it first and try running this script again."
  exit
end

# Initialize an empty repository called merge-conflict.
g = Git.init('merge-conflict')


# Create a README.md file and commit it to the repository
readme_text = "# Merge Conflicts\n\nThis repository demonstrates how merge conflicts occur."

File.open('merge-conflict/README.md', 'w') do | f |
  f.puts(readme_text)
end

g.add
g.commit('Initial commit.')

initial_commit_id = g.log.first.sha[0..6]


# Create a feature branch from the initial commit
g.branch('feature').checkout


# Add text to the README.md file and commit the changes on the feature branch.
feature_readme_addition_text = "\n\nA feature branch was created off of the `Initial commit` at `#{initial_commit_id}`.  This line was added to the file on the feature branch."

File.open('merge-conflict/README.md', 'a') do | f |
  f.puts feature_readme_addition_text
end

g.add
g.commit('Add line to feature branch')


# Checkout the master branch
g.checkout('master')


# Add text to the README.md file and commit the changes on the master branch
master_readme_addition_text = "\n\nA feature branch was created off of the initial commit (`#{initial_commit_id}`).  However, work on `master` progressed in parallel to the work on `feature`.  Since both branches contain commits after their common ancestor (#{initial_commit_id}), the `master` and `feature` branches have now diverged.  This is not always a problem, but since the same line (this line) was modified on both branches, Git does not know which version is the correct one.  At this point, if you try to merge `feature` into `master`, you will encounter a merge conflict."

File.open('merge-conflict/README.md', 'a') do | f |
  f.puts master_readme_addition_text
end

g.add
g.commit('Add line to master branch')
