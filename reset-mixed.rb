#!/usr/bin/env ruby

# Generate a repository where using `git-reset --mixed` would be a good strategy.
# When run, this will create a new repository within which you can do a mixed
# reset to restructure commits to tell a different story.

require 'gitmethere'

if Dir.exists?('git-reset-mixed')
  puts "It looks like you have a directory called 'git-reset-mixed' in this directory.\nPlease delete it first and then try running this script again."
  exit
end


# Initialize a repository
name = 'git-reset-mixed'
explanation = "# Git Reset (mixed)

When you are working on a feature or bug, you will often find it helpful to create frequent commits that track your overall progress.  When it is time to share your changes, however, those commits may not be structured and ordered in a way that is best for historical reference.  Using the command `git reset --mixed` allows you to step backwards in your commit history while leaving the changes in your working directory intact but unstaged so you can re-stage related pieces of work and craft a commit history that better represents individual development steps.

It is kind of like restringing a guitar.  You might replace and tune each string one at a time.  But maybe it makes more sense to group all of the replacement work together, separate from the tuning work for each string.  Instead of a history that looks like:

```
1. Replace low-E string
2. Tune low-E string
3. Replace A string
4. Tune A string...
```

You could roll back and regroup those units of work so that similar tasks are part of the same commits.

This repository contains folders that each represent a string on a guitar.  You have a branch called `replace-strings` that contains individual commits for each step of the restringing process.  If you run `git reset --mixed HEAD~12`, Git will rewind your commit history back to 12 commits ago, leaving all of the changes those commits introduced intact but unstaged.  From there, run you can re-add your files to the staging area and create new commits structured in a way that tells a clearer story of the changes you made.

For instance, you might want to stage all of the `*/string-info.md` files for one commit and stage all of the `tuning-info.md` files for another commit."

scenario = GitMeThere::Scenario.new(name, explanation)


# Create commits for each of the strings being replaced and tuned

guitar_strings = [
  'low-E',
  'A',
  'D',
  'G',
  'B',
  "high-E"
]

scenario.checkout_branch('replace-strings')

guitar_strings.each do | s |

  Dir.mkdir("#{name}/#{s}")

  scenario.create_file("#{s}/string-info.md", "#{s} string replaced at #{Time.now}.")
  scenario.stage_changes
  scenario.commit("Replace #{s} string")

  scenario.create_file("#{s}/tuning-info.md", "#{s} tuned at #{Time.now}.")
  scenario.stage_changes
  scenario.commit("Tune #{s} string")

end
