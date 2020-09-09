#!/usr/bin/env ruby

# Write the current commit hash and major/minor version to
# App/Resources/release.json. Add a signed tag pointing at
# head to mark the release.

# The minor version is bumped by default. Pass "major" to
# bump that number instead.

require 'json'

if !system('git diff-index --quiet --cached head')
  STDERR.puts 'fatal: dirty index'
  exit 1
end

release = {'version': 'v0.0', 'commit': 'unknown'}

path = './App/Resources/release.json'
File.open(path, "r+") do |file|
  release = JSON.load(file)

  maj, min = release['version'].match(/v(\d+)\.(\d+)/).captures
  case ARGV.first
  when 'major'
    release['version'] = "v#{maj.to_i+1}.0"
  when 'minor'
    release['version'] = "v#{maj}.#{min.to_i+1}"
  end

  commit = `git rev-parse --short=11 head`.chomp
  release['commit'] = commit

  file.rewind
  file.truncate 0
  JSON.dump(release, file)
end

`git add #{path}`
`git commit -m 'release: #{release['version']}'`

tag = release['version']
if system("git show-ref --quiet #{tag}")
  STDERR.puts "warning: replaced existing tag"
end
`git tag -fs -m "release ${tag}" #{tag}`
