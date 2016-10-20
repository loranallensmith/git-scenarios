#!/usr/bin/env ruby

# Generate a repository with a merge conflict on the horizon.
# When run, this will create a new repository within which the
# user will experience a merge conflict upon running `git merge feature`

require 'gitmethere'

if Dir.exists?('merge-conflict')
  puts "It looks like you have a directory called 'merge-conflict' in this directory.\nPlease delete it first and try running this script again."
  exit
end

# Initialize an empty repository called merge-conflict.
setup = {
  name: "merge-conflict",
  explanation: "# Merge Conflicts\n\nThis repository demonstrates how merge conflicts occur."
}

scenario = GitMeThere::Scenario.new(setup[:name], setup[:explanation])

initial_commit_id = scenario.g.log.first.sha[0..6]


# Create a feature branch from the initial commit
scenario.checkout_branch('feature')


# Add text to the README.md file and commit the changes on the feature branch.
feature_readme_addition_text = "\n\nA feature branch was created off of the `Initial commit` at `#{initial_commit_id}`.  This line was added to the file on the feature branch."

scenario.append_to_file("README.md", feature_readme_addition_text)
scenario.stage_changes
scenario.commit("Add line to feature branch")


# Checkout the master branch
scenario.checkout_branch('master')


# Add text to the README.md file and commit the changes on the master branch
master_readme_addition_text = "\n\nA feature branch was created off of the initial commit (`#{initial_commit_id}`).  However, work on `master` progressed in parallel to the work on `feature`.  Since both branches contain commits after their common ancestor (#{initial_commit_id}), the `master` and `feature` branches have now diverged.  This is not always a problem, but since the same line (this line) was modified on both branches, Git does not know which version is the correct one.  At this point, if you try to merge `feature` into `master`, you will encounter a merge conflict."

scenario.append_to_file("README.md", master_readme_addition_text)
scenario.stage_changes
scenario.commit("Add line to master branch")
