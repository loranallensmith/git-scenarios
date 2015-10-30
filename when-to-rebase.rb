#!/usr/bin/env ruby

# Generate a repository where using git-rebase would be a good strategy.
# When run, this will create a new repository within which the
# master branch has progressed past the point where feature branch was created.

require 'git'

if Dir.exists?('when-to-rebase')
  puts "It looks like you have a directory called 'when-to-rebase' in this directory.\nPlease delete it first and try running this script again."
  exit
end

# Initialize an empty Git repository called 'when-to-rebase'

g = Git.init('when-to-rebase')

# Create a README.md file and commit it to the repository
readme_text = "# When to Rebase

  Because the `master` branch is constantly receiving updates from new commits and merged Pull Requests, choosing the right time to create your `feature` branch can be intimidating.  With `git-rebase`, the answer is right now.

  In its simplest form, rebasing lets you take your current branch and shift it in its entirety so that it begins at a different point in history.  This means you can create a branch when you are ready, pull any updates from `master`, and then move your feature branch to current tip of `master` as though you had created your branch right now instead of yesterday or two weeks ago.  In addition to ensuring your branch contains the most up-to-date work, rebasing is often helpful for ensuring commits on your branch apply cleanly via a fast-forward merge instead of creating merge commits, which can clutter the history of a project.

  It is kind of like building a car.  Different people are working on different components at the same time — wheels, chassis, engine, transmission.  You want to make sure you have the most recent components so you can make sure the bodywork you are building fits with everything else that is already done.

  The `master` branch of this repository contains files representing each of those components.  Every part was added with a separate commit.  You have a branch called `car-body` that you started immediately after the initial commit.  However, work has progressed on the `master` branch since then.  You need to make sure your frame takes into consideration all of the other components that are already part of the car before you add it in.

  If you check out your `car-body` branch and run `$ git rebase master`, Git will look at all of the commits that exist on your branch and recreate them so that they are based on (and therefore include) the most recent commits on `master`."


File.open('when-to-rebase/README.md', 'w') do | f |
  f.puts(readme_text)
end

g.add
g.commit('Initial commit')

initial_commit_id = g.log.first.sha[0..6]


# Create a car-body branch from the initial commit
g.branch('car-body').checkout


# Create a body.md file and commit it to the car-body branch
car_frame_text = "This is the body of the car.  It not only gives the car added structure and safety, but also makes the car stylish and aerodynamic."

File.open('when-to-rebase/body.md', 'w') do | f |
  f.puts(car_frame_text)
end

g.add
g.commit('Add car body')


# Checkout the master branch
g.checkout('master')

# Create files for car components and add them in separate commits
files_to_commit = [
  {'name' => 'wheels', 'content' => 'These are the wheels.  They ensure the car can roll smoothly.'},
  {'name' => 'chassis', 'content' => 'This is the chassis.  It is the structure upon which all other components sit.'},
  {'name' => 'engine', 'content' => 'This is the engine.  It gives the car power.'},
  {'name' => 'transmission', 'content' => 'This is the transmission.  It controls the application of power from the engine.'}
]

files_to_commit.each do | file |

  File.open("when-to-rebase/#{file['name']}.md", 'w') do | f |
    f.puts "#{file['content']}"
  end

  g.add

  g.commit("Add #{file['name']} to car")

end
