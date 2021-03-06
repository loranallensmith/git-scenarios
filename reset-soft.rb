#!/usr/bin/env ruby

# Generate a repository where using `git-reset --soft` would be a good strategy.
# When run, this will create a new repository within which you can do a soft
# reset to combine many commits into a single one.

require 'gitmethere'

if Dir.exists?('git-reset-soft')
  puts "It looks like you have a directory called 'git-reset-soft' in this directory.\nPlease delete it first and then try running this script again."
  exit
end

name = 'git-reset-soft'
explanation = "# Git Reset (soft)

  When you are working a feature or bug, you will often find it helpful to create frequent commits that track your overall progress.  When it is time to share your changes, however, you may not want each step to appear in the history of the project.  Using the command `git reset --soft` allows you to step backwards in your commit history while leaving your working directory and staging area intact so you can combine all of those commits into a single snapshot.

  It is kind of like remodeling a kitchen.  Maybe there are multiple contractors who are each responsible for a particular component.  The person overseeing the overall progress might not necessarily be concerned with how each component is constructed — only that the components are complete and installed.

  This repository contains files that each represent a finished component of a kitchen remodel.  You have a branch called `flooring` that contains individual commits for each step of the flooring process.  If you run `git reset --soft HEAD~5`, Git will rewind your commit history, leaing all of the changes those commits introduced intact and staged.  From there, you can run `git commit -m 'Add flooring'` to combine all of those individual changes into a single commit."


# Initialize an empty git repository
scenario = GitMeThere::Scenario.new(name, explanation)

initial_commit_id = scenario.g.log.first.sha[0..6]


# Create commits for each of the kitchen components being added

appliances_to_add = [
  {'name' => 'stove',
    'content' => "# Stove\n- Remove old appliance\n- Sweep up\n- Check electrical connections\n- Install new stove"},
  {'name' => 'countertops',
    'content' => "# Countertops\n- Remove old countertops\n- Ensure countertops will fit new cabinets\n- Install new countertops\n- Dispose of surplus material"},
  {'name' => 'cabinets',
    'content' => "# Cabinets\n- Remove old cabinets\n- Measure for fit\n- Install cabinets\n- Level cabinets and doors\n- Clean up"},
  {'name' => 'lighting',
    'content' => "# Lighting\n- Remove old fixtures\n- Replace wiring\n- Install medallions\n- Install lights\n- Repair ceiling"}
]

appliances_to_add.each do | file |
  scenario.create_file(file['name'], file['content'])
  scenario.stage_changes
  scenario.commit("Add #{file['name']}")
end


# Create a feature branch for the flooring and add each step for the flooring in a separate commit.

scenario.checkout_branch('flooring')

scenario.create_file('flooring.md', "# Flooring\n")

flooring_steps = [
  "Remove old flooring and adhesive",
  "Install new boards",
  "Let wood breathe",
  "Sand boards",
  "Apply finish"
]

flooring_steps.each do | step |
  scenario.append_to_file('flooring.md', "- #{step}")
  scenario.stage_changes
  scenario.commit("#{step}")

end
