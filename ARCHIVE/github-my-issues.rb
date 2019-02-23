#!/usr/bin/env ruby
#Source: https://gist.github.com/copiousfreetime/960999
#
# A quick script to dump an overview of all the open issues in all my github projects
#
 
require 'octokit'
require 'awesome_print'
require 'rainbow'
 
options = {
:login => %x[ git config --get github.user ].strip,
:token => %x[ git config --get github.token ].strip
}
 
client = Octokit::Client.new( options )
key_width = 15
label_color = Hash.new( :cyan )
 
label_color['bug'] = :red
label_color['feature'] = :green
label_color['todo'] = :blue
 
client.list_repos.each do |repo|
next if repo.fork
next unless repo.open_issues > 0
 
print "Repository : ".rjust( key_width ).foreground( :green ).bright
puts repo.name
 
print "Issue Count : ".rjust( key_width ).foreground( :yellow ).bright
puts repo.open_issues
 
client.issues( repo ).each do |issue|
print ("%3d : " % issue.number).rjust( key_width).foreground( :white ).bright
labels = []
if not issue.labels.empty? then
issue.labels.each do |l|
labels << l.foreground( label_color[l] ).bright
end
end
print labels.join(' ') + " "
puts issue.title
end
puts
end
